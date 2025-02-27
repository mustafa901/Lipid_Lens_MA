import streamlit as st
import cv2
import numpy as np
from skimage import morphology, measure, segmentation, feature, filters
import matplotlib.pyplot as plt
import scipy.ndimage as ndi

# Streamlit app title
st.title("Lipid Lens")

# Upload image
uploaded_file = st.file_uploader("Upload an image of lipid droplets", type=["jpg", "jpeg", "png", "tif"])

if uploaded_file is not None:
    # Read the uploaded image
    file_bytes = np.asarray(bytearray(uploaded_file.read()), dtype=np.uint8)
    image = cv2.imdecode(file_bytes, cv2.IMREAD_COLOR)

    # Convert to grayscale if the image is in color
    if len(image.shape) == 3:
        image_gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    else:
        image_gray = image

    # Display the original image
    st.subheader("Original Image")
    st.image(image, caption="Uploaded Image", use_column_width=True)

    # Define a range of potential threshold values for testing
    threshold_values = np.linspace(40, 300, num=50)  # Adjust this based on your observations

    # Determine the number of figures we need to plot all the thresholds
    num_figures = len(threshold_values) // 12 + (1 if len(threshold_values) % 12 > 0 else 0)

    # Initialize the plot index
    plot_index = 1

    # Iterate over the threshold values and plot the binary images and counts
    for thresh_val in threshold_values:
        # When the current figure is filled, create a new one
        if plot_index % 13 == 1:
            fig = plt.figure(figsize=(15, 15))

        # Apply binary thresholding without inversion if droplets are darker than the background
        _, binary_image = cv2.threshold(image_gray, thresh_val, 255, cv2.THRESH_BINARY)

        # Remove small objects (noise) from the binary image
        binary_image = morphology.remove_small_objects(binary_image, min_size=20)

        # Apply morphological closing to fill holes within the droplets
        selem = morphology.disk(2)  # Adjust size based on droplet size
        binary_image = morphology.closing(binary_image, selem)

        # Label the objects
        label_image, num_labels = ndi.label(binary_image)

        # Plot the binary image with the count as the title
        plt.subplot(3, 4, plot_index % 12 if plot_index % 12 != 0 else 12)
        plt.imshow(binary_image, cmap='gray')
        plt.title(f'Threshold: {thresh_val:.0f}\nCount: {num_labels}')
        plt.axis('off')

        # Increment the plot index and show the figure when filled
        if plot_index % 12 == 0:
            plt.tight_layout()
            st.pyplot(fig)

        plot_index += 1

    # Show the last figure if it's not full
    if (plot_index - 1) % 12 != 0:
        plt.tight_layout()
        st.pyplot(fig)
