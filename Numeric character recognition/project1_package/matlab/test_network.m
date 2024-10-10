%% Network defintion
layers = get_lenet();

%% Loading data
fullset = false;
[xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset);

% load the trained weights
load lenet.mat

%% Testing the network
% Modify the code to get the confusion matrix
prediction = zeros(1,size(xtest,2));
for i=1:100:size(xtest, 2)
     [output, P] = convnet_forward(params, layers, xtest(:, i:i+99));
     [probability, index_max] = max(P, [], 1);
     prediction(:, i:i+99) = index_max;
end

 Compare = confusionmat(ytest, prediction);
 confusionchart(Compare, [0:9])

%%  Check how the training data picture look like
%  for j=1:10
%     image_src_test = sprintf('../images/test/%d.jpg', j);
%     some_test = xtrain(:,j);
%     col2img = reshape(some_test, 28, 28);
%     imwrite(col2img.', image_src_test);
%  end

