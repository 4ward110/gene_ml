%% Import data
data_file = 'GSE66099.csv';
degs_file = 'gene_diff_data.csv';

label = 'Died';

DEGs = readtable(degs_file);
gene_id = DEGs.('X');
A = [];
for i = 1:length(gene_id)
%     gene_id(i) = cell2mat(gene_id(i));
    A = [A string(cell2mat(gene_id(i)))];
end

data = readtable(data_file);
gene_data = [];
for i = 1:length(A)
    gene_data = [gene_data data.(A(i))];
end
gene_data = [gene_data data.('Died')];
gene_data_norm = [];
%% Normalize data
for i = 1 : length(gene_data(1,:))
    norm_data = nml(gene_data(:,i));
    gene_data_norm(:,i) = norm_data;
end

%% Train/Test split
X = gene_data_norm(:,1:108);
Y = gene_data_norm(:,109);
% Cross validation (train 70%, test 30%)

% Filter data based on labels
pos = gene_data_norm(gene_data_norm(:,109)==1,:);
neg = gene_data_norm(gene_data_norm(:,109)==0,:);

% Training and test data for positive label

train_ind = sort(randperm(size(pos,1),ceil(0.7*size(pos,1))));
test_ind = 1:size(pos,1);
test_ind(train_ind) = [];

pos_train = pos(train_ind,:);
pos_test = pos(test_ind,:);

% Trainine and test data for negative label

train_ind2 = sort(randperm(size(neg,1),ceil(0.7*size(neg,1))));
test_ind2 = 1:size(neg,1);
test_ind2(train_ind2) = [];

neg_train = neg(train_ind2,:);
neg_test = neg(test_ind2,:);

% Concat 2 matrix vertically

trainData = vertcat(neg_train,pos_train);
testData = vertcat(neg_test,pos_test);

% Shuffle data
[m,n] = size(trainData);
idx = randperm(m);
trainData = trainData(idx,:);

X_train = trainData(:,1:108);
y_train = trainData(:,109);


[x,y] = size(testData);
idx2 = randperm(x);
testData = testData(idx2,:);

X_test = testData(:,1:108);
y_test = testData(:,109);


%% Training with SVM/ RF/ Logistic 

SVMModel = fitcsvm(X_train,y_train,'KernelFunction','linear','Standardize',false);

SVMModel = fitPosterior(SVMModel);
[~,scores2] = resubPredict(SVMModel);
[x2,y2,t2,auc2] = perfcurve(y_train,scores2(:,2),1);
figure
subplot(1,2,1)
plot(x2,y2,'LineWidth',2.0)
xlabel('False positive rate'); ylabel('True positive rate');
legend('Support Vector Machines','Location','Best')
title('ROC for classification by SVM-train');


[y_pred, score] = predict(SVMModel, X_test);
[x,y,t,auc] = perfcurve(y_test,score(:,2),1);
subplot(1,2,2)
plot(x,y,'LineWidth',2.0)
xlabel('False positive rate'); ylabel('True positive rate');
legend('Support Vector Machines','Location','Best')
title('ROC for classification by SVM-test');

confusionchart(y_test, y_pred)
M = evaluate(y_pred, y_test);

%% Sequential feature selection
% get score off all feature
gene_score = zeros(1,108);
ratio = 0.8;
[X_train1,X_test1,y_train1,y_test1] = train_test_strategy(trainData,ratio);

for i = 1:108
%     total = 0;
    % fit to a logistic regression
    mdlNB = fitcnb(X_train1(:,i),y_train1(:,1));
%     SVMModel = fitcsvm(X_train1(:,i),y_train1(:,1),'KernelFunction','linear','KernelScale','auto');
%     mdl = fitglm(X_train1(:,i),y_train1(:,:),'Distribution','binomial','Link','logit');
    [y_pred1, score1] = predict(mdlNB, X_test1(:,i));
    result = evaluate(y_pred1, y_test1(:,1));
    result('acc')
%     X_train1(:,i)
%     gene_score(i) = result('acc');
end

%% K-fold split
% s = trainData(:,109);
% cv = cvpartition(s,'KFold',5,'Stratify',true);




