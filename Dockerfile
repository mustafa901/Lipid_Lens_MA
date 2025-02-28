# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app/

# Install system dependencies for OpenCV
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create the package structure
RUN mkdir -p lipid_lens

# Create the app.py file
RUN echo 'import streamlit as st\nimport cv2\nimport numpy as np\nfrom skimage import morphology, measure, segmentation, feature, filters\nimport matplotlib.pyplot as plt\nimport scipy.ndimage as ndi\n\ndef main():\n    # Streamlit app title\n    st.title("Lipid Lens")\n\n    # Upload image\n    uploaded_file = st.file_uploader("Upload an image of lipid droplets", type=["jpg", "jpeg", "png", "tif"])\n\n    if uploaded_file is not None:\n        # Read the uploaded image\n        file_bytes = np.asarray(bytearray(uploaded_file.read()), dtype=np.uint8)\n        image = cv2.imdecode(file_bytes, cv2.IMREAD_COLOR)\n\n        # Convert to grayscale if the image is in color\n        if len(image.shape) == 3:\n            image_gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)\n        else:\n            image_gray = image\n\n        # Display the original image\n        st.subheader("Original Image")\n        st.image(image, caption="Uploaded Image", use_column_width=True)\n\n        # Define a range of potential threshold values for testing\n        threshold_values = np.linspace(40, 300, num=50)  # Adjust this based on your observations\n\n        # Determine the number of figures we need to plot all the thresholds\n        num_figures = len(threshold_values) // 12 + (1 if len(threshold_values) % 12 > 0 else 0)\n\n        # Initialize the plot index\n        plot_index = 1\n\n        # Iterate over the threshold values and plot the binary images and counts\n        for thresh_val in threshold_values:\n            # When the current figure is filled, create a new one\n            if plot_index % 13 == 1:\n                fig = plt.figure(figsize=(15, 15))\n\n            # Apply binary thresholding without inversion if droplets are darker than the background\n            _, binary_image = cv2.threshold(image_gray, thresh_val, 255, cv2.THRESH_BINARY)\n\n            # Remove small objects (noise) from the binary image\n            binary_image = morphology.remove_small_objects(binary_image, min_size=20)\n\n            # Apply morphological closing to fill holes within the droplets\n            selem = morphology.disk(2)  # Adjust size based on droplet size\n            binary_image = morphology.closing(binary_image, selem)\n\n            # Label the objects\n            label_image, num_labels = ndi.label(binary_image)\n\n            # Plot the binary image with the count as the title\n            plt.subplot(3, 4, plot_index % 12 if plot_index % 12 != 0 else 12)\n            plt.imshow(binary_image, cmap="gray")\n            plt.title(f"Threshold: {thresh_val:.0f}\\nCount: {num_labels}")\n            plt.axis("off")\n\n            # Increment the plot index and show the figure when filled\n            if plot_index % 12 == 0:\n                plt.tight_layout()\n                st.pyplot(fig)\n\n            plot_index += 1\n\n        # Show the last figure if it is not full\n        if (plot_index - 1) % 12 != 0:\n            plt.tight_layout()\n            st.pyplot(fig)\n\nif __name__ == "__main__":\n    main()' > lipid_lens/app.py

# Create the __init__.py file
RUN echo '"""Lipid Lens - A Streamlit application for analyzing lipid droplets in images."""\n\n__version__ = "0.1.0"' > lipid_lens/__init__.py

# Create requirements.txt file
RUN echo 'streamlit>=1.0.0\nopencv-python>=4.0.0\nscikit-image>=0.18.0\nnumpy>=1.19.0\nmatplotlib>=3.3.0\nscipy>=1.5.0' > requirements.txt

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 8501 available to the world outside this container
EXPOSE 8501

# Define environment variable
ENV NAME LipidLens

# Run app.py when the container launches
CMD ["streamlit", "run", "lipid_lens/app.py"]