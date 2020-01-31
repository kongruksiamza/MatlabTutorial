foregroundDetector = vision.ForegroundDetector('NumGaussians',3, ...
    'NumTrainingFrames', 50);

videoReader = vision.VideoFileReader('visiontraffic.avi');
for i = 1:150
    frame = step(videoReader);
    foreground = step(foregroundDetector, frame);
end

se = strel('square', 3);
filteredForeground = imopen(foreground, se);
figure; imshow(filteredForeground); title('Clean Foreground');

blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 150);
bbox = step(blobAnalysis, filteredForeground);

numCars = size(bbox, 1);
result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');
result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
          'FontSize', 14);
figure; imshow(result); title('Detected Cars');



videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
videoPlayer.Position(3:4) = [650,400];
se = strel('square', 3);
while ~isDone(videoReader)
    frame = step(videoReader);
    foreground = step(foregroundDetector, frame);
    filteredForeground = imopen(foreground, se);
    bbox = step(blobAnalysis, filteredForeground);
    result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');
    numCars = size(bbox, 1);
    result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
        'FontSize', 14);
    step(videoPlayer, result);
end
release(videoReader);