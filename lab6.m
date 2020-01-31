I = imread('keypad.jpg');
I = rgb2gray(I);
figure;
imshow(I)
% Run OCR on the image
results = ocr(I);

results.Text