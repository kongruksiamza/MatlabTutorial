clc;
a=imread('numbers001.tif');
b=ocr(a);
c=insertObjectAnnotation(a,'rectangle',b.WordBoundingBoxes,b.WordConfidences);
imshow(c);
clc;