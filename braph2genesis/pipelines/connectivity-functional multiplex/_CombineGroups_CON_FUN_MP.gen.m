%% ¡header!
CombineGroups_CON_FUN < Element (co, combiner of CON and FUN subject groups) combines a group of subjects with connectivity data with a group of subjects with functional data.

%%% ¡description!
CombineGroups_CON_FUN combines a group of subjects with connectivity data with a group of subjects with functional data.
Combines the data uploaded through the connectivity and functional workflows. The ID and covariates of subjects are
copied from the first group, in this case connectivity.

%%% ¡seealso!
SubjectCON_FUN_MP, SeparateGroups_CON_FUN

%% ¡props_update!

%%% ¡prop!
NAME (constant, string) is the name of the subject.
%%%% ¡default!
'SubjectCON_FUN_MP'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of the subject.
%%%% ¡default!
'Subject with connectivity and functional data (e.g. obtained from DTI and fMRI). The first layer contains a connectivity matrix and the second layer contains functional data.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of the subject.
%%% ¡settings!
'SubjectCON_FUN_MP'

%%% ¡prop!
ID (data, string) is a few-letter code for the subject.
%%%% ¡default!
'SubjectCON_FUN_MP ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of the subject.
%%%% ¡default!
'SubjectCON_FUN_MP label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the subject.
%%%% ¡default!
'SubjectCON_FUN_MP notes'

%% ¡props!

%%% ¡prop!
WAITBAR (metadata, logical) detemines whether to show the waitbar.

%%% ¡prop!
GR1 (data, item) is a group of subjects with connectivity data.
%%%% ¡default!
Group('SUB_CLASS', 'SubjectCON')

%%% ¡prop!
GR2 (data, item) is a group of subjects with functional data.
%%%% ¡default!
Group('SUB_CLASS', 'SubjectFUN')

%%% ¡prop!
GR (result, item) is a group of subjects with connectivity and functional data.
%%%% ¡settings!
'Group'
%%%% ¡check_value!
check = any(strcmp(value.get(Group.SUB_CLASS_TAG), subclasses('SubjectCON_FUN_MP', [], [], true)));
%%%% ¡default!
Group('SUB_CLASS', 'SubjectCON_FUN_MP', 'SUB_DICT', IndexedDictionary('IT_CLASS', 'SubjectCON_FUN_MP'))
%%%% ¡calculate!
wb = braph2waitbar(co.get('WAITBAR'), 0, 'Combining subject groups ...');

% creates empty Group
gr = Group( ...
    'SUB_CLASS', 'SubjectCON_FUN_MP', ...
    'SUB_DICT', IndexedDictionary('IT_CLASS', 'SubjectCON_FUN_MP') ...
    );

% get connectivity and functional groups
group1 = co.get('GR1');
group2 = co.get('GR2');

% assert that the 2 groups have the same number of subjects
assert(isequal(group1.get('SUB_DICT').length(), group2.get('SUB_DICT').length()), ...
    [BRAPH2.STR ':CombineGroups_CON_FUN:' BRAPH2.BUG_ERR], ...
    ['The 2 groups to be combined need to have the same number of subjects while ', ...
    'group 1 has ' tostring(group1.get('SUB_DICT').length()) ' subjects and group 2 has ' tostring(group2.get('SUB_DICT').length()) ' subjects.'])

% sets group props
gr.set( ...
    'ID', group1.get('ID'), ...
    'LABEL', group1.get('LABEL'), ...
    'NOTES', 'Combined group with CON and FUN data'...
    );

subdict = gr.get('SUB_DICT');
subdict_gr1 = group1.get('SUB_DICT');
subdict_gr2 = group2.get('SUB_DICT');

for i = 1:1:group1.get('SUB_DICT').length()
    braph2waitbar(wb, .30 + .70 * i / group1.get('SUB_DICT').length(), ['Combining subject ' num2str(i) ' of ' num2str(group1.get('SUB_DICT').length()) ' ...'])

    sub1 = subdict_gr1.getItem(i);
    sub2 = subdict_gr2.getItem(i);
    CON_FUN_MP = cell(2, 1);
    CON_FUN_MP(1) = {sub1.get('CON')};
    CON_FUN_MP(2) = {sub2.get('FUN')};
    
    % add CON_FUN_MP subject
    sub = SubjectCON_FUN_MP( ...
        'ID', sub1.get('ID'), ...
        'BA', sub1.get('BA'), ...
        'CON_FUN_MP', CON_FUN_MP, ...
        'age', sub1.get('age'), ...
        'sex', sub1.get('sex') ...
        );
    subdict.add(sub);
end
gr.set('sub_dict', subdict);

value = gr;

braph2waitbar(wb, 'close')