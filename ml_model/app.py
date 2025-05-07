import numpy as np
# import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
# import cv2

model = tf.keras.models.load_model("model.keras")
image_path = r"C:\Users\Administrator\Desktop\5th-yr-project\back-end app\images\hgic-veg-septoria-leaf-spot-600.jpg"

# img = cv2.imread(image_path)
# img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

image = tf.keras.preprocessing.image.load_img(image_path, target_size=(128, 128))
input_arr = tf.keras.preprocessing.image.img_to_array(image)
input_arr = np.array([input_arr])  # Convert single image to a batch.
print(input_arr.shape)

predictions = model.predict(input_arr)
predictions, predictions.shape

result_index = np.argmax(predictions)
result_index

class_names = ['Tomato_Bacterial_spot',
 'Tomato_Early_blight',
 'Tomato_Late_blight',
 'Tomato_Leaf_Mold',
 'Tomato_Septoria_leaf_spot',
 'Tomato_Spider_mites_Two_spotted_spider_mite',
 'Tomato__Target_Spot',
 'Tomato__Tomato_YellowLeaf__Curl_Virus',
 'Tomato__Tomato_mosaic_virus',
 'Tomato_healthy']

# Displaying Result of disease prediction
models_predictions = class_names[result_index]
models_predictions