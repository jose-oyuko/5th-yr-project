import streamlit as st
import tensorflow as tf
import numpy as np
import requests

def gpt_advice(disease_name):
    url = "https://payload.vextapp.com/hook/XJOWCO5HU5/catch/hello"
    headers = {
        "Content-Type": "application/json",
        "ApiKey": "Api-Key W315hWGM.cdAgsdg8IyShB1boucXsv84LMwKtgUVq"
    }
    data = {
    "payload": disease_name
}
    response = requests.post(url, headers=headers, json=data)
    if response.status_code == 200:
        response_data = response.json()
        advice = response_data.get("text", "No advice found.")
        
        return advice
    else:
        return "Error: Unable to fetch advice."


#Tensorflow Model Prediction
def model_prediction(test_image):
    model = tf.keras.models.load_model("model.keras")
    image = tf.keras.preprocessing.image.load_img(test_image,target_size=(128,128))
    input_arr = tf.keras.preprocessing.image.img_to_array(image)
    input_arr = np.array([input_arr]) #convert single image to batch
    predictions = model.predict(input_arr)
    return np.argmax(predictions) #return index of max element

#Sidebar
st.sidebar.title("Dashboard")
app_mode = st.sidebar.selectbox("Select Page",["Home","About","Disease Recognition"])

#Main Page
if(app_mode=="Home"):
    st.header("PLANT DISEASE RECOGNITION SYSTEM")
    # image_path = "home_page.jpeg"
    # st.image(image_path,use_column_width=True)
    st.markdown("""
    Welcome to the Plant Disease Recognition System! 🌿🔍
    
    Our mission is to help in identifying plant diseases efficiently. Upload an image of a plant, and our system will analyze it to detect any signs of diseases. Together, let's protect our crops and ensure a healthier harvest!

    ### How It Works
    1. **Upload Image:** Go to the **Disease Recognition** page and upload an image of a plant with suspected diseases.
    2. **Analysis:** Our system will process the image using advanced algorithms to identify potential diseases.
    3. **Results:** View the results and recommendations for further action.

    ### Why Choose Us?
    - **Accuracy:** Our system utilizes state-of-the-art machine learning techniques for accurate disease detection.
    - **User-Friendly:** Simple and intuitive interface for seamless user experience.
    - **Fast and Efficient:** Receive results in seconds, allowing for quick decision-making.

    ### Get Started
    Click on the **Disease Recognition** page in the sidebar to upload an image and experience the power of our Plant Disease Recognition System!

    ### About Us
    Learn more about the project, our team, and our goals on the **About** page.
    """)

#About Project
elif(app_mode=="About"):
    st.header("About")
    st.markdown("""
                #### About Dataset
                This dataset is recreated using offline augmentation from the original dataset.The original dataset can be found on this github repo.
                This dataset consists of about 87K rgb images of healthy and diseased crop leaves which is categorized into 38 different classes.The total dataset is divided into 80/20 ratio of training and validation set preserving the directory structure.
                A new directory containing 33 test images is created later for prediction purpose.
                #### Content
                1. train (70295 images)
                2. test (33 images)
                3. validation (17572 images)

                """)

#Prediction Page
elif(app_mode=="Disease Recognition"):
    st.header("Disease Recognition")
    test_image = st.file_uploader("Choose an Image:")
    
    # Clear session state when a new image is uploaded
    if 'previous_image' not in st.session_state:
        st.session_state.previous_image = None
    
    if test_image != st.session_state.previous_image:
        st.session_state.prediction = None
        st.session_state.chat_history = []
        st.session_state.previous_image = test_image
    
    if(st.button("Show Image")):
        st.image(test_image,width=4,use_column_width=True)
    
    # Initialize session state for prediction and chat history
    if 'prediction' not in st.session_state:
        st.session_state.prediction = None
    if 'chat_history' not in st.session_state:
        st.session_state.chat_history = []
    
    #Predict button
    if(st.button("Predict")):
        with st.spinner('Analyzing image...'):
            st.write("Our Prediction")
            result_index = model_prediction(test_image)
            #Reading Labels
            class_name = ['Tomato_Bacterial_spot',
 'Tomato_Early_blight',
 'Tomato_Late_blight',
 'Tomato_Leaf_Mold',
 'Tomato_Septoria_leaf_spot',
 'Tomato_Spider_mites_Two_spotted_spider_mite',
 'Tomato__Target_Spot',
 'Tomato__Tomato_YellowLeaf__Curl_Virus',
 'Tomato__Tomato_mosaic_virus',
 'Tomato_healthy']
            prediction = class_name[result_index]
            st.session_state.prediction = prediction
            st.success("Model is Predicting it's a {}".format(prediction))
            
            # Automatically get advice after prediction
            with st.spinner('Fetching advice...'):
                advice = gpt_advice(prediction)
            st.info("Advice for {}:".format(prediction))
            st.write(advice)
            # Add initial advice to chat history
            st.session_state.chat_history.append({"role": "assistant", "content": advice})
    
    # Chat interface - only show if we have a prediction
    if st.session_state.prediction is not None:
        st.markdown("---")
        st.subheader("Ask Follow-up Questions")
        
        # Display chat history
        for message in st.session_state.chat_history:
            if message["role"] == "user":
                st.chat_message("user").write(message["content"])
            else:
                st.chat_message("assistant").write(message["content"])
        
        # Chat input
        if prompt := st.chat_input("Ask a follow-up question"):
            # Add user message to chat history
            st.session_state.chat_history.append({"role": "user", "content": prompt})
            
            # Get response from gpt_advice
            with st.spinner('Thinking...'):
                response = gpt_advice(prompt)
            
            # Add assistant response to chat history
            st.session_state.chat_history.append({"role": "assistant", "content": response})
            
            # Rerun to update the chat display
            st.rerun()
