# HandwrittenDiary-OCR

HandwrittenDiary-OCR is a tool designed to digitize handwritten Chinese diary entries using Optical Character Recognition (OCR) technology. It was created to convert decades of personal handwritten Chinese diaries into electronic documents, while also serving as a way to get familiar with Python programming. The tool uses Baidu OCR for recognizing Chinese text from handwritten images and supports processing multiple images in batch.

## Requirements

- Baidu OCR API credentials

## Usage

1. **Download the repository**:

   Download or clone the entire repository to your local machine:

2. **Apply for Baidu OCR API Key**:

   - Go to [Baidu Smart Cloud OCR](https://login.bce.baidu.com/) and apply for an API key.

   - Save the API key to `config/BaiduOCRKey.txt` in the following format:

     ```
     API_KEY=your_api_key
     SECRET_KEY=your_secret_key
     ```

3. **Run the tool**:

   After setting up the API key, you can run the tool by executing `main.exe`. Once launched, a GUI will automatically appear. The GUI allows you to select a folder for batch processing of multiple images.

   The recognized text for each image will be saved in the specified output folder.

## License

This project is licensed under the MIT License.
