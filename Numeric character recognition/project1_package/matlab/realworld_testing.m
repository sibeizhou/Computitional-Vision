samples = zeros(784,7);
%% Loading data
for i = 0:6
    image_src = sprintf('../images/realworld_test/%d.jpg', i);
    image_in = rgb2gray(im2double(imread(image_src))).';
    img2col = reshape(image_in, [], 1);
    samples(:, i+1) = img2col;

    % Reverse the pictures to white numbers on black background
    % image_src2 = sprintf('../images/numbers/reverse%d.jpg', i);
    % image_2 = imcomplement(imread(image_src);
    % imwrite(image_2, image_src2);
end

% load the trained weights
load lenet.mat

%% Network defintion
layers = get_lenet();
layers{1,1}.batch_size = size(samples,2);

%% Testing the network
% Modify the code to get the confusion matrix
ytest = [0:6];

[output, P] = convnet_forward(params, layers, samples);
[probability, index_max] = max(P, [], 1);

Compare = confusionmat(ytest, index_max-1);
confusionchart(Compare, [0:6])

