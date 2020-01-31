function coinDetection
    close all;
    orig_color = imread('cointest.jpg');
    orig_grays = rgb2gray(orig_color);
    % Otsu's method
    thresh = graythresh(orig_grays);
    % Thresholding
    filter_image = im2bw(orig_grays, thresh);
   
    % Inverse Image
    filter_image = 1-filter_image;
    % Region Filling
    filter_image = imfill(filter_image,'holes');
    
    % Sobel Mask
    mask = [ -1 0 1; -2 0 2; -1 0 1 ];

    % Find gx and gy
    gx = filter2(mask,filter_image,'same');
    gy = filter2(mask',filter_image,'same');
    
    filter_image = mat2gray(sqrt(gx.^2 + gy.^2));
    radii = 31:1:50;
    hough = circle_hough(filter_image, radii, 'same', 'normalise');
    peaks = circle_houghpeaks(hough, radii, 'nhoodxy', 15, 'nhoodr', 21);
    peaks = peaks';

    % Count rows
    [rows , ~] = size(peaks);

    % Separate raduis
    radii = peaks(:, 3);
    % Separate centers
    centers = peaks(:, 1:2);

    fprintf('---------------------\n');
    fprintf('%d coins found.\n', rows);
    fprintf('---------------------\n');

    % Make image with coins type
    getCoinType(orig_color, centers, radii, rows);

    % plot centers and border
    hold on;
    viscircles(centers, radii, 'EdgeColor', 'g');
    viscircles(centers, ones(1,rows), 'Color', 'g');
    hold off;
end

function getCoinType(orig_image, centers, radii, rows)
    positions = [];
    coins = cell(1, rows);
  
    for row = 1:rows
        % for c
        r = floor(radii(row) ^ 2);
        % x axis
        x = floor(centers(row, 1));
        % y axis
        y = floor(centers(row, 2));
        % Pythagoras [ c = sqrt(r^2 + r^2) ]
        c = floor(sqrt(r * 2));

        % Position top & left of rectangle
        x_top = x - c / 2;
        y_top = y - c / 2;

        % Crop image form original image
        cropped = imcrop(orig_image, [x_top, y_top, c, c]);

        % Find rgb in image cropped
        r = floor(mean2(cropped(:,:,1)));
        g = floor(mean2(cropped(:,:,2)));
        b = floor(mean2(cropped(:,:,3)));

        % Add position
        positions = cat(1, positions, [x_top, y_top]);
        % Add coin id
        text = int2str(row);

        % Find color of coin
        if (100 < r) && (r < 140) && (70 < g) && (g < 100) && (50 < b) && (b < 90)
            text = strcat(text, ': copper');
        elseif (120 < r) && (r < 140) && (100 < g) && (g < 120) && (65 < b) && (b < 100)
            text = strcat(text, ': gold');
        elseif (r < 120) && (g < 120) && (b < 120)
            text = strcat(text, ': silver');
        end
        
        % Add coin color
        coins{row} = text;
    end
    
    % Inset Text to image with positions and coins text
    imshow(insertText(orig_image, positions, coins));
end
