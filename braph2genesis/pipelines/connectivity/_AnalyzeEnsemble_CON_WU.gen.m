%% ¡header!
AnalyzeEnsemble_CON_WU < AnalyzeEnsemble (a, graph analysis with connectivity data) is a ensenmble-based graph analysis using connectivity data.

%%% ¡description!
This ensemble-based graph analysis (AnalyzeEnsemble_CON_WU) analyzes connectivity data using weighted undirected graphs.

%%% ¡seealso!
SubjectCON, GraphWU

%% ¡props_update!

%%% ¡prop!
NAME (constant, string) is the name of the ensenmble-based graph analysis using connectivity data.
%%%% ¡default!
'AnalyzeEnsemble_CON_WU'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of the ensenmble-based graph analysis using connectivity data.
%%%% ¡default!
'This ensemble-based graph analysis (AnalyzeEnsemble_CON_WU) analyzes connectivity data using weighted undirected graphs.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of the ensenmble-based graph analysis using connectivity data.
%%%% ¡settings!
'AnalyzeEnsemble_CON_WU'

%%% ¡prop!
ID (data, string) is a few-letter code for the ensenmble-based graph analysis using connectivity data.
%%%% ¡default!
'AnalyzeEnsemble_CON_WU ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of the ensenmble-based graph analysis using connectivity data.
%%%% ¡default!
'AnalyzeEnsemble_CON_WU label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the ensenmble-based graph analysis using connectivity data.
%%%% ¡default!
'AnalyzeEnsemble_CON_WU notes'

%%% ¡prop!
GR (data, item) is the subject group, which also defines the subject class SubjectCON.
%%%% ¡default!
Group('SUB_CLASS', 'SubjectCON')

%%% ¡prop!
GRAPH_TEMPLATE (parameter, item) is the graph template to set all graph and measure parameters.
%%%% ¡settings!
'GraphWU'

%%% ¡prop!
G_DICT (result, idict) is the graph (GraphWU) ensemble obtained from this analysis.
%%%% ¡settings!
'GraphWU'
%%%% ¡calculate!
g_dict = IndexedDictionary('IT_CLASS', 'GraphWU');
gr = a.get('GR');

% % % ba = BrainAtlas();
% % % if ~isempty(gr) && ~isa(gr, 'NoValue') && gr.get('SUB_DICT').length > 0 
% % %     ba = gr.get('SUB_DICT').getItem(1).get('BA');
% % % end

for i = 1:1:gr.get('SUB_DICT').get('LENGTH')
	sub = gr.get('SUB_DICT').get('IT', i);
    g = GraphWU( ...
        'ID', ['graph ' sub.get('ID')], ... 
        'TEMPLATE', a.memorize('GRAPH_TEMPLATE'), ... % % % 'BAS', ba, ...
        'B', sub.getCallback('CON') ...
        );
    g_dict.get('ADD', g)
end

value = g_dict;

%%% ¡prop!
ME_DICT (result, idict) contains the calculated measures of the graph ensemble.
%%%% ¡_gui!
% % % pr = PPAnalyzeEnsemble_ME_DICT('EL', a, 'PROP', AnalyzeEnsemble_CON_WU.ME_DICT, 'WAITBAR', true, varargin{:});

%% ¡tests!

%%% ¡test!
%%%% ¡name!
Example
%%%% ¡probability!
.01
%%%% ¡code!
if ~isfile([fileparts(which('SubjectCON')) filesep 'Example data CON XLS' filesep 'atlas.xlsx'])
    test_ImporterGroupSubjectCON_XLS % create example files
end

example_CON_WU

%%% ¡test!
%%%% ¡name!
GUI - Analysis
%%%% ¡probability!
.01
%%%% ¡parallel!
false
%%%% ¡code!
% % % im_ba = ImporterBrainAtlasXLS('FILE', 'destrieux_atlas.xlsx');
% % % ba = im_ba.get('BA');
% % % 
% % % gr = Group('SUB_CLASS', 'SubjectST', 'SUB_DICT', IndexedDictionary('IT_CLASS', 'SubjectST'));
% % % for i = 1:1:50
% % %     sub = SubjectST( ...
% % %         'ID', ['SUB ST ' int2str(i)], ...
% % %         'LABEL', ['Subejct ST ' int2str(i)], ...
% % %         'NOTES', ['Notes on subject ST ' int2str(i)], ...
% % %         'BA', ba, ...
% % %         'ST', rand(ba.get('BR_DICT').get('LENGTH'), 1) ...
% % %         );
% % %     sub.memorize('VOI_DICT').get('ADD', VOINumeric('ID', 'Age', 'V', 100 * rand()))
% % %     sub.memorize('VOI_DICT').get('ADD', VOICategoric('ID', 'Sex', 'CATEGORIES', {'Female', 'Male'}, 'V', randi(2, 1)))
% % %     gr.get('SUB_DICT').get('ADD', sub)
% % % end
% % % 
% % % a = AnalyzeGroup_ST_WU('GR', gr, 'CORRELATION_RULE', Correlation.PEARSON);
% % % 
% % % gui = GUIElement('PE', a, 'CLOSEREQ', false);
% % % gui.get('DRAW')
% % % gui.get('SHOW')
% % % 
% % % gui.get('CLOSE')

%%% ¡test!
%%%% ¡name!
GUI - Comparison
%%%% ¡probability!
.01
%%%% ¡parallel!
false
%%%% ¡code!
% % % im_ba = ImporterBrainAtlasXLS('FILE', 'destrieux_atlas.xlsx');
% % % ba = im_ba.get('BA');
% % % 
% % % gr1 = Group('SUB_CLASS', 'SubjectST', 'SUB_DICT', IndexedDictionary('IT_CLASS', 'SubjectST'));
% % % for i = 1:1:50
% % %     sub = SubjectST( ...
% % %         'ID', ['SUB ST ' int2str(i)], ...
% % %         'LABEL', ['Subejct ST ' int2str(i)], ...
% % %         'NOTES', ['Notes on subject ST ' int2str(i)], ...
% % %         'BA', ba, ...
% % %         'ST', rand(ba.get('BR_DICT').get('LENGTH'), 1) ...
% % %         );
% % %     sub.memorize('VOI_DICT').get('ADD', VOINumeric('ID', 'Age', 'V', 100 * rand()))
% % %     sub.memorize('VOI_DICT').get('ADD', VOICategoric('ID', 'Sex', 'CATEGORIES', {'Female', 'Male'}, 'V', randi(2, 1)))
% % %     gr1.get('SUB_DICT').get('ADD', sub)
% % % end
% % % 
% % % gr2 = Group('SUB_CLASS', 'SubjectST', 'SUB_DICT', IndexedDictionary('IT_CLASS', 'SubjectST'));
% % % for i = 1:1:50
% % %     sub = SubjectST( ...
% % %         'ID', ['SUB ST ' int2str(i)], ...
% % %         'LABEL', ['Subejct ST ' int2str(i)], ...
% % %         'NOTES', ['Notes on subject ST ' int2str(i)], ...
% % %         'BA', ba, ...
% % %         'ST', rand(ba.get('BR_DICT').get('LENGTH'), 1) ...
% % %         );
% % %     sub.memorize('VOI_DICT').get('ADD', VOINumeric('ID', 'Age', 'V', 100 * rand()))
% % %     sub.memorize('VOI_DICT').get('ADD', VOICategoric('ID', 'Sex', 'CATEGORIES', {'Female', 'Male'}, 'V', randi(2, 1)))
% % %     gr2.get('SUB_DICT').get('ADD', sub)
% % % end
% % % 
% % % a1 = AnalyzeGroup_ST_WU('GR', gr1, 'CORRELATION_RULE', Correlation.PEARSON);
% % % a2 = AnalyzeGroup_ST_WU('GR', gr2, 'TEMPLATE', a1);
% % % 
% % % c = CompareGroup( ...
% % %     'P', 10, ...
% % %     'A1', a1, ...
% % %     'A2', a2, ...
% % %     'WAITBAR', true, ...
% % %     'VERBOSE', false, ...
% % %     'MEMORIZE', true ...
% % %     );
% % % 
% % % gui = GUIElement('PE', c, 'CLOSEREQ', false);
% % % gui.get('DRAW')
% % % gui.get('SHOW')
% % % 
% % % gui.get('CLOSE')