clear;
warning('off','all');

ytest1 = [1,2,3,4,5,6,7,8,9,0];
ytest2 = [1,2,3,4,5,6,7,8,9,0];
ytest3 = [6,0,6,2,4];
ytest4 = [7,0,3,9,1,7,2,6,6,1,4,3,4,9,1,2,4,0,5,0,4,4,7,3,1,2,5,0,5,1,7,7,9,4,1,7,4,9,2,1,3,5,2,4,0,9,4,4,1,1];

load lenet.mat
layers = get_lenet();

thresholds = [0.5, 0.5, 0.5, 0.96];
thresholds2 = [0.5, 0.7, 0.5, 0.5];
for test = 1:4
    img_src = sprintf('../images/image%d.jpg', test);
    image = rgb2gray(im2double(imread(img_src)));

    % 1. Classify each pixel as foreground 
    % or background pixel with threshold = 0.6
    threshold = thresholds(test);
    threshold2 = thresholds2(test);
    foreground = image;
    foreground_2 = image;
   
    foreground(foreground < threshold) = 0;
    foreground(foreground >= threshold) = 1;

    foreground_2(foreground_2 < threshold2) = 0;
    foreground_2(foreground_2 >= threshold2) = 1;


    background = imcomplement(foreground);
    background_2 = imcomplement(foreground_2);
    % figure();
    % imshow(foreground);

    % 2.1. Find connected components 
    comp_matrix = bwlabel(background);

    % 2.2. Place a bounding box around each character
    img_reg = regionprops(comp_matrix, 'area', 'boundingbox');
    areas = [img_reg.Area];  
    rects = cat(1, img_reg.BoundingBox); 

    % show all the connected region in rectangles
    figure(test);  
    imshow(image); 
    count_number = 0;
    for i = 1:size(rects, 1)
        if areas(i) > 20
            rectangle('position', rects(i, :), 'EdgeColor', 'r'); 
            count_number = count_number + 1;
        end
    end
    saveas(gcf,sprintf('../images/bound_box/image%d_boundBox.jpg', test));
    
    % 3.1. Take each bounding box
    % pad it if necessary and resize it to 28×28
    samples = zeros(784,count_number);
    count = 1;
    for i = 1:size(rects, 1)
        if areas(i) > 20
            box = rects(i, :);
            img_input = background_2(box(2):box(2)+box(4)-1, box(1):box(1)+box(3)-1); 
            
            % padding it to a square
            x = size(img_input,1);
            y = size(img_input,2);
            diff = abs(x-y);
            extra_padding_rate = 0.25;   % change to get different accurancy
            if x > y
                img_input = padarray(img_input,[0 floor(diff/2)],0,"both");
                img_input = padarray(img_input,[floor(extra_padding_rate*x) floor(extra_padding_rate*x)],0,"both");
            elseif x < y
                img_input = padarray(img_input,[floor(diff/2) 0],0,"both");
                img_input = padarray(img_input,[floor(extra_padding_rate*y) floor(extra_padding_rate*y)],0,"both");
            else
                img_input = padarray(img_input,[floor(extra_padding_rate*y) floor(extra_padding_rate*y)],0,"both");
            end
            
            % resize it to 28×28
            img_input_src = sprintf('../images/ec_inputs/test%d_%d.jpg', test, count);
            img_input1 = imresize(img_input,[28 28]);
            imwrite(img_input1, img_input_src);
            
            image_in = im2double(imread(img_input_src)).';
            img2col = reshape(image_in, [], 1);
            samples(:, count) = img2col;
            count = count + 1;
        end
    end

    % 3.2. Pass it through the network
    layers = get_lenet();
    layers{1,1}.batch_size = size(samples,2);
    if test == 1
        ytest = ytest1;
    elseif test == 2
        ytest = ytest2;
    elseif test == 3
        ytest = ytest3;
    else
        ytest = ytest4;
    end

    [output, P] = convnet_forward(params, layers, samples);
    [probability, index_max] = max(P, [], 1);
    
    correct = sum(ytest == index_max-1);
    fprintf("Testing image%d.jpg, got accuracy at %d/%d (%d%%)\n",test, correct, count-1, 100*correct/(count-1));
end


