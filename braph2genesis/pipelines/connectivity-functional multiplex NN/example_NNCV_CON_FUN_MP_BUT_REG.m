%% EXAMPLE_NNCV_CON_FUN_MP_BUT_ME_REG
% Script example pipeline for NN regression cross-validation with input of MultiplexBUT measures derived from SubjectCON_FUN_MP 

clear variables %#ok<*NASGU>

%% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(which('NNDataPoint_CON_FUN_MP_REG')) filesep 'Example data NN REG CON_FUN_MP XLS' filesep 'atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');

%% Load Groups of SubjectCON
im_gr = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('NNDataPoint_CON_FUN_MP_REG')) filesep 'Example data NN REG CON_FUN_MP XLS' filesep 'Connectivity' filesep 'CON_FUN_MP_Group_XLS'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr_CON = im_gr.get('GR');

%% Load Groups of SubjectFUN
im_gr = ImporterGroupSubjectFUN_XLS( ...
    'DIRECTORY', [fileparts(which('NNDataPoint_CON_FUN_MP_REG')) filesep 'Example data NN REG CON_FUN_MP XLS' filesep 'Functional' filesep 'CON_FUN_MP_Group_XLS'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr_FUN = im_gr.get('GR');

%% Combine Groups of SubjectCON with Groups of SubjectFUN
co_gr = CombineGroups_CON_FUN_MP( ...
    'GR_CON', gr_CON, ...
    'GR_FUN', gr_FUN, ...
    'WAITBAR', true ...
    );

gr = co_gr.get('GR_CON_FUN_MP');

%% Analysis CON FUN MP BUT
thresholds = .7;
a_BUT = AnalyzeEnsemble_CON_FUN_MP_BUT( ...
    'GR', gr, ...
    'THRESHOLDS', thresholds ...
    );

a_BUT.get('MEASUREENSEMBLE', 'Degree').get('M');
a_BUT.get('MEASUREENSEMBLE', 'DegreeAv').get('M');
a_BUT.get('MEASUREENSEMBLE', 'Distance').get('M');

%% create item lists of NNDataPoint_Graph_REG
it_list = cellfun(@(g, sub) NNDataPoint_Graph_REG( ...
    'ID', sub.get('ID'), ...
    'G', g, ...
    'SUB', sub, ...
    'TARGET_IDS', sub.get('VOI_DICT').get('KEYS')), ...
    a_BUT.get('G_DICT').get('IT_LIST'), gr.get('SUB_DICT').get('IT_LIST'),...
    'UniformOutput', false);

% create NNDataPoint_Graph_REG DICT items
dp_list = IndexedDictionary(...
        'IT_CLASS', 'NNDataPoint_Graph_REG', ...
        'IT_LIST', it_list ...
        );

% create a NNDataset containing the NNDataPoint_Graph_REG DICT
d = NNDataset( ...
    'DP_CLASS', 'NNDataPoint_Graph_REG', ...
    'DP_DICT', dp_list ...
    );

%% Create a regressor cross-validation
nne_template = NNRegressorMLP_Evaluator('P', 2);
nncv = NNRegressorMLP_CrossValidation('D', {d}, 'KFOLDS', 2, 'NNEVALUATOR_TEMPLATE', nne_template);
nncv.get('TRAIN');

%% Evaluate the performance
av_corr_coeff = nncv.get('AV_CORR');
av_coeff_determination = nncv.get('AV_DET');
av_mae = nncv.get('AV_MAE');
av_mse = nncv.get('AV_MSE');
av_rmse = nncv.get('AV_RMSE');
av_fi = nncv.get('AV_FEATURE_IMPORTANCE');