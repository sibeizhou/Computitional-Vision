layers = get_lenet();
load lenet.mat
% load data
% Change the following value to true to load the entire dataset.
fullset = false;
[xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset);
xtrain = [xtrain, xvalidate];
ytrain = [ytrain, yvalidate];
m_train = size(xtrain, 2);
batch_size = 64;
 
 
layers{1}.batch_size = 1;
img = xtest(:, 1);
img = reshape(img, 28, 28);
figure();
imshow(img');
saveas(gcf,'../results/original.jpg');
 
%[cp, ~, output] = conv_net_output(params, layers, xtest(:, 1), ytest(:, 1));
output = convnet_forward(params, layers, xtest(:, 1));
output_1 = reshape(output{1}.data, 28, 28);
% Fill in your code here to plot the features.
% Figure 1
figure_data1 = reshape(output{1,2}.data,output{1,2}.height, output{1,2}.width,output{1,2}.channel);
figure();
title('Feature maps of the second layer');
for fig = 1:20
    subplot(4,5,fig);
    h(fig) = imshow(figure_data1(:,:,fig).', []);
end
saveas(gcf,'../results/cov_layer.jpg');

% Figure 2
figure_data2 = reshape(output{1,3}.data,output{1,3}.height, output{1,3}.width,output{1,3}.channel);
figure();
title('Feature maps of the third layer');
for fig = 1:20
    subplot(4,5,fig);
    h(fig) = imshow(figure_data2(:,:,fig).', []);
end
saveas(gcf,'../results/relu_layer.jpg')

