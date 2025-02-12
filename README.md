# Lipid_Lens_MA Documentation

## Overview
The **Lipid Droplet Analyzer App** is a web-based application designed to analyze images of lipid droplets. It allows users to upload an image, apply various thresholding techniques to segment the lipid droplets, and visualize the results. The app is built using **Streamlit**, a popular framework for creating data science and machine learning applications.

This documentation provides a comprehensive guide to the app, including its features, how to use it, and technical details for developers.

---

## Features
1. **Image Upload**: Users can upload an image of lipid droplets in common formats (JPEG, PNG).
2. **Grayscale Conversion**: The app automatically converts the uploaded image to grayscale for processing.
3. **Thresholding**: A range of threshold values is applied to segment the lipid droplets.
4. **Noise Removal**: Small objects (noise) are removed from the binary image.
5. **Morphological Operations**: Morphological closing is applied to fill holes within the droplets.
6. **Object Labeling**: The app labels and counts the detected lipid droplets.
7. **Visualization**: The app displays the binary images for each threshold value along with the count of detected droplets.

---

## How to Use the App

### Prerequisites
1. Install Python (version 3.7 or higher).
2. Install the required libraries using the following command:
   ```bash
   pip install streamlit opencv-python scikit-image numpy matplotlib scipy
   ```

### Running the App
1. Save the provided code in a file named `app.py`.
2. Open a terminal and navigate to the directory containing `app.py`.
3. Run the app using the following command:
   ```bash
   streamlit run app.py
   ```
4. The app will open in your default web browser.

### Using the App
1. **Upload an Image**:
   - Click the "Upload an image of lipid droplets" button.
   - Select an image file (JPEG or PNG) from your computer.

2. **View the Original Image**:
   - The uploaded image will be displayed under the "Original Image" section.

3. **Analyze the Image**:
   - The app will automatically process the image and display the results.
   - For each threshold value, a binary image and the count of detected lipid droplets will be shown.

4. **Interpret the Results**:
   - Examine the binary images to determine the optimal threshold value for your analysis.
   - Use the droplet count to quantify the lipid droplets in the image.

---

## Technical Details

### Code Structure
The app consists of the following components:

1. **Image Upload**:
   - The `st.file_uploader` widget allows users to upload an image.
   - The uploaded image is read using `cv2.imdecode`.

2. **Grayscale Conversion**:
   - The image is converted to grayscale using `cv2.cvtColor`.

3. **Thresholding**:
   - A range of threshold values is defined using `np.linspace`.
   - Binary thresholding is applied using `cv2.threshold`.

4. **Noise Removal**:
   - Small objects are removed using `skimage.morphology.remove_small_objects`.

5. **Morphological Closing**:
   - Holes within the droplets are filled using `skimage.morphology.closing`.

6. **Object Labeling**:
   - Objects are labeled using `scipy.ndimage.label`.

7. **Visualization**:
   - The binary images and droplet counts are displayed using `matplotlib.pyplot`.

### Key Parameters
- **Threshold Range**: Defined by `np.linspace(40, 300, num=50)`. Adjust these values based on your image characteristics.
- **Noise Removal**: The `min_size` parameter in `remove_small_objects` is set to 20. Adjust this to filter out smaller or larger objects.
- **Morphological Closing**: The `selem` parameter in `morphology.closing` is set to a disk of size 2. Adjust this based on the size of the holes in your droplets.

---

## Customization
You can customize the app to better suit your needs:

1. **Adjust Threshold Range**:
   - Modify the `threshold_values` array to test different ranges of threshold values.

2. **Change Morphological Operations**:
   - Experiment with different structuring elements (`selem`) for morphological operations.

3. **Add Advanced Features**:
   - Incorporate additional image processing techniques, such as edge detection or watershed segmentation.
   - Add functionality to save the results or export the data.

---

## Example Use Case
### Scenario:
A researcher wants to analyze an image of lipid droplets to determine the optimal threshold value for segmentation and count the number of droplets.

### Steps:
1. The researcher uploads the image using the app.
2. The app processes the image and displays the binary images for various threshold values.
3. The researcher examines the results and selects the threshold value that best segments the droplets.
4. The app provides the count of detected droplets for the selected threshold value.

---

## Troubleshooting
1. **Image Not Uploading**:
   - Ensure the image file is in a supported format (JPEG, PNG).
   - Check the file size (very large files may cause issues).

2. **Poor Segmentation Results**:
   - Adjust the threshold range and morphological parameters.
   - Preprocess the image (e.g., enhance contrast) before uploading.

3. **App Crashes**:
   - Ensure all required libraries are installed.
   - Check for errors in the terminal and debug the code.

---

## Future Enhancements
1. **Interactive Threshold Selection**:
   - Allow users to interactively select the optimal threshold value.

2. **Batch Processing**:
   - Enable users to upload and process multiple images at once.

3. **Export Results**:
   - Add functionality to save the binary images and droplet counts.

4. **Advanced Analysis**:
   - Incorporate machine learning models for more accurate segmentation.

---

## Conclusion
The **Lipid Droplet Analyzer App** is a powerful tool for analyzing images of lipid droplets. It provides a user-friendly interface for segmentation, noise removal, and droplet counting. By following this documentation, users can effectively use the app and customize it to meet their specific needs.

For any questions or feedback, please contact me at linkden: mustafa-al-bayati1212. Happy Lipid analyzing! 🚀
