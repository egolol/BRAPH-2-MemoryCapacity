%% ¡header!
NNClassifierEvaluator < NNEvaluator (nne, evaluator of a neural network classifier) evaluates the performance of a neural network classifier with a specific dataset.

%% ¡description!
This evaluator evaluates the performance of a neural network classifier
in terms of the receiver operating characteristic curve (ROC), the area 
under the ROC curve (AUC), and the confusion matrix.

%% ¡props!
%%% ¡prop!
PLOT_CM (data, logical) is an option for the plot of the confusion matrix.
%%%% ¡default!
false

%%% ¡prop!
PLOT_MAP (data, logical) is an option for the plot of the feature map.
%%%% ¡default!
false

%%% ¡prop!
PLOT_ROC (data, logical) is an option for the plot of the receiver operating characteristic curve.
%%%% ¡default!
false

%%% ¡prop!
AUC (result, cell) is an area under the curve score obtained from the dataset.
%%%% ¡calculate!
pred = nne.memorize('PREDICTION');
targets = nne.get('NNDATA').memorize('TARGETS');
if(isempty(targets{1}))
    value = {};
else
    classes = [string(nne.get('NNDATA').get('TARGET_NAME_GR1')), string(nne.get('NNDATA').get('TARGET_NAME_GR2'))];
    targets = onehotdecode(targets{1}, classes, 2);
    classifier = nne.get('NN');
    net = classifier.to_net(classifier.get('MODEL'));
    [X, Y, T, auc] = perfcurve(targets, pred(:,2), classes(2));
    if nne.get('PLOT_ROC')
        plot(X, Y, 'LineWidth', 3.0, 'Color', 'Black')
        xlabel('False positive rate')
        ylabel('True positive rate')
        title('ROC for Classification')
        legend(sprintf('ROC (AU-ROC = %.2f)', auc), 'Location', 'southeast', 'FontSize', 12);
        legend('boxoff');
        directory = [fileparts(which('test_braph2')) filesep 'NN_saved_figures'];
        if ~exist(directory, 'dir')
            mkdir(directory)
        end
        filename = [directory filesep 'roc.svg'];
        saveas(gcf, filename);
    end

    value = {auc, X, Y};
end

%%% ¡prop!
VAL_AUC (result, scalar) is an area under the curve score obtained from the validation set.
%%%% ¡calculate!
pred = nne.memorize('VAL_PREDICTION');
targets = nne.get('NNDATA').memorize('VAL_TARGETS');
if(isempty(targets{1}))
    value = {};
else
    classes = [string(nne.get('NNDATA').get('TARGET_NAME_GR1')), string(nne.get('NNDATA').get('TARGET_NAME_GR2'))];
    targets = onehotdecode(targets{1}, classes, 2);
    classifier = nne.get('NN');
    net = classifier.to_net(classifier.get('MODEL'));
    [X, Y, T, auc] = perfcurve(targets, pred(:,2), classes(2));
    if nne.get('PLOT_ROC')
        plot(X, Y, 'LineWidth', 3.0, 'Color', 'Black')
        xlabel('False positive rate')
        ylabel('True positive rate')
        title('ROC for Classification')
        legend(sprintf('ROC (AU-ROC = %.2f)', auc), 'Location', 'southeast', 'FontSize', 12);
        legend('boxoff');
        directory = [fileparts(which('test_braph2')) filesep 'NN_saved_figures'];
        if ~exist(directory, 'dir')
            mkdir(directory)
        end
        filename = [directory filesep 'val_roc.svg'];
        saveas(gcf, filename);
    end

    value = {auc, X, Y};
end

%%% ¡prop!
CONFUSION_MATRIX (result, matrix) is a confusion matrix obtained with a cut-off of 0.5.
%%%% ¡calculate!
% get prediction
preds = nne.memorize('PREDICTION');
preds = preds > 0.5;

% get ground truth
classes = [string(nne.get('NNDATA').get('TARGET_NAME_GR1')), string(nne.get('NNDATA').get('TARGET_NAME_GR2'))];
targets = nne.get('NNDATA').memorize('TARGETS');
if(isempty(targets{1}))
    value = [];
else
    targets_mark = categories(onehotdecode(targets{1}, classes, 2));
    known = targets{1};

    % calculate the confusion matrix
    [cm, order] = confusionmat(known(:,2), double(preds(:,2)));
    if nne.get('PLOT_CM')
        figure
        heatmap(targets_mark, targets_mark, cm)
        directory = [fileparts(which('test_braph2')) filesep 'NN_saved_figures'];
        if ~exist(directory, 'dir')
            mkdir(directory)
        end
        filename = [directory filesep 'confusion_matrix.svg'];
        saveas(gcf, filename);
    end

    value = cm;
end

%%% ¡prop!
VAL_CONFUSION_MATRIX (result, matrix) is a confusion matrix obtained with a cut-off of 0.5.
%%%% ¡calculate!
% get prediction
preds = nne.memorize('VAL_PREDICTION');
preds = preds > 0.5;

% get ground truth
classes = [string(nne.get('NNDATA').get('TARGET_NAME_GR1')), string(nne.get('NNDATA').get('TARGET_NAME_GR2'))];
targets = nne.get('NNDATA').memorize('VAL_TARGETS');
if(isempty(targets{1}))
    value = [];
else
    targets_mark = categories(onehotdecode(targets{1}, classes, 2));
    known = targets{1};

    % calculate the confusion matrix
    [cm, order] = confusionmat(known(:,2), double(preds(:,2)));
    if nne.get('PLOT_CM')
        figure
        heatmap(targets_mark, targets_mark, cm)
        directory = [fileparts(which('test_braph2')) filesep 'NN_saved_figures'];
        if ~exist(directory, 'dir')
            mkdir(directory)
        end
        filename = [directory filesep 'val_confusion_matrix.svg'];
        saveas(gcf, filename);
    end

    value = cm;
end

%%% ¡prop!
FEATURE_MAP (result, matrix) is a feature map obtained with feature selection analysis.
%%%% ¡calculate!
selected_idx = nne.get('NNDATA').get('FEATURE_MASK');
if length(selected_idx) == 1 && abs(selected_idx) <= 1
    selected_idx = nne.get('NNDATA').get('FEATURE_MASK_ANALYSIS');
end
if ~isempty(selected_idx)
    if string(nne.get('NNDATA').get('INPUT_TYPE')) == 'graph_measures'
        feature = nne.get('NNDATA').get('MEASURES');
        fm = zeros(1, length(feature));
        ticklabel = feature;
        fontsize = 12;
    else
        feature = nne.get('NNDATA').get('TRAIN_G_DICT_1').getItem(1).get('A');
        fm = zeros(length(feature{1}));
        ticklabel = 0:size(fm, 2);
        fontsize = 5;
    end

    fm(selected_idx) = 1;

    if nne.get('PLOT_MAP')
        figure
        x = [1 size(fm, 2)];
        y = [0 size(fm, 1)];
        image(x, y, fm, 'CDataMapping', 'scaled')

        xticks([1:size(fm, 2)]);
        yticks([1:size(fm, 1)]);
        xticklabels(ticklabel);
        yticklabels(0:size(fm, 1));
        a = get(gca,'XTickLabel');
        set(gca, 'XTickLabel', a, 'fontsize', fontsize, 'FontWeight', 'bold')
        a = get(gca,'YTickLabel');
        set(gca, 'YTickLabel', a, 'fontsize', fontsize, 'FontWeight', 'bold')
        colorbar
        directory = [fileparts(which('test_braph2')) filesep 'NN_saved_figures'];
        if ~exist(directory, 'dir')
            mkdir(directory)
        end
        filename = [directory filesep 'connection_mask.svg'];
        saveas(gcf, filename);
    end

    value = fm;
else
    value = [];
end

%% ¡props_update!
%%% ¡prop!
NNDATA (data, item) is a dataset for testing the neural networks.
%%%% ¡settings!
'NNClassifierData'
%%%% ¡default!
NNClassifierData()

%%% ¡prop!
PREDICTION (result, matrix) is an output matrix of prediction from a neural network model.
%%%% ¡calculate!
nnd = nne.get('NNDATA');
inputs = nnd.memorize('INPUTS');
if isempty(inputs{1})
    value = [];
else
    classifier = nne.get('NN');
    net = classifier.to_net(classifier.get('MODEL'));
    inputs = inputs{1};
    inputs = reshape(inputs, [1, 1, size(inputs,1), size(inputs,2)]);

    value = net.predict(inputs);
end

%%% ¡prop!
VAL_PREDICTION (result, matrix) is an output matrix of prediction for the validation set.
%%%% ¡calculate!
nnd = nne.get('NNDATA');
inputs = nnd.memorize('VAL_INPUTS');
if isempty(inputs{1})
    value = [];
else
    classifier = nne.get('NN');
    net = classifier.to_net(classifier.get('MODEL'));

    inputs = inputs{1};
    inputs = reshape(inputs, [1, 1, size(inputs,1), size(inputs,2)]);

    value = net.predict(inputs);
end
