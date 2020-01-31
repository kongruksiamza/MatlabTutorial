clc;
% Load an image
I = imread('IMG_20150311_180207.jpg');

% Perform OCR
results = ocr(I);

% Display one of the recognized words
word = results.Words{1}
wordBBox = results.WordBoundingBoxes(1,:)
% Show the location of the word in the original image
figure;
Iname = insertObjectAnnotation(I, 'rectangle', wordBBox, word);
imshow(Iname);