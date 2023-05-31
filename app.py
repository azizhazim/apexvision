from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from PIL import Image
import io
import re
import base64
import openai
import pytesseract
import logging

logging.basicConfig(level=logging.INFO)

# Set up Flask app and CORS
app = Flask(__name__)
CORS(app)

# Set up OpenAI key and Google credentials
#openai.api_key = os.getenv("OPENAI_KEY")
openai.api_key = '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'

def preprocess(text):
    lines = text.split('\n')
    question = lines[0]
    answers = lines[1:]
    labeled_answers = [f"{answer}" for i, answer in enumerate(answers)]
    return question + "\n" + "\n".join(labeled_answers)

def get_answer_from_gpt3(preprocessed_text):
    messages = [
        {
            "role": "system",
            "content": (
                "You are an AI trained on a diverse range of internet text. "
                "You will be given a question with options following it. You are to read "
                "the question and the options carefully, critically analyze each option, "
                "compare them, and then determine the most accurate answer based on the "
                "information provided and your vast training data. Respond by saying "
                "'The correct answer is:' followed by the full text of the correct answer. "
                "Remember, only provide the final answer and ensure that it's the most "
                "precise choice possible."
            ),
        },
        {"role": "user", "content": preprocessed_text},
    ]

    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=messages,
        temperature=0.2,
    )

    app.logger.info(f'GPT-3 response: {response}')

    ai_output = response['choices'][0]['message']['content']
    prefix = "The correct answer is: "
    if ai_output.startswith(prefix):
        return ai_output[len(prefix):]
    else:
        return "I'm sorry, but I couldn't determine a clear answer."

@app.route('/get_answer', methods=['POST'])
def get_answer():
    try:
        image_str = request.json['image']
        image_data = re.sub('^data:image/.+;base64,', '', image_str)
        image_data = base64.b64decode(image_data)
        image = Image.open(io.BytesIO(image_data))

        # Use pytesseract to extract text from image
        text = pytesseract.image_to_string(image)
        
        app.logger.info(f'Extracted text: {text}')

        # Preprocess the extracted text
        preprocessed_text = preprocess(text)
        app.logger.info(f'Preprocessed text: {preprocessed_text}')

        # Now use OpenAI GPT-3 to answer the question
        answer = get_answer_from_gpt3(preprocessed_text)
        app.logger.info(f'Final answer: {answer}')

        return jsonify({'answer': answer})

    except Exception as e:
        app.logger.exception(f'Error: {str(e)}')
        return jsonify({'error': str(e)}), 500

