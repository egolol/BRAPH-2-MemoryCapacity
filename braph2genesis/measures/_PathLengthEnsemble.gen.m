%% ¡header!
PathLengthEnsemble < PathLength (m, pathlength of a graph ensemble) is the pathlength of a graph ensemble.

%%% ¡description!
The path length is the average shortest path length of one node to all
other nodes within a layer.

%%% ¡compatible_graphs!
GraphBUEnsemble
GraphWUEnsemble
MultiplexBUEnsemble
MultiplexWUEnsemble

%% ¡props_update!

%%% ¡prop!
M (result, cell) is the ensemble-averaged pathlength.
%%%% ¡calculate!
ge = m.get('G'); % graph ensemble from measure class

pathlength_ensemble = cell(ge.layernumber(), 1);

pathlength_list = cellfun(@(x) x.getMeasure('PathLength').get('M'), ge.get('G_DICT').getItems, 'UniformOutput', false);
for li = 1:1:ge.layernumber()
    pathlength_li_list = cellfun(@(x) x{li}, pathlength_list, 'UniformOutput', false);
    pathlength_ensemble{li} = mean(cat(3, pathlength_li_list{:}), 3);
end

value = pathlength_ensemble;

%% ¡tests!

%%% ¡test!
%%%% ¡name!
GraphBUEnsemble
%%%% ¡code!
B = [
    0   .1  0   0
    .2  0   .1  0
    0   .1  0   .2
    0   0   .1  0
    ];

known_pathlength = {[2 4/3 4/3 2]'};

ge = GraphBUEnsemble();
dict = ge.get('G_DICT');
for i = 1:1:10
    g = GraphBU( ...
        'ID', ['g ' int2str(i)], ...
        'B', B ...
        );
    dict.add(g)
end
ge.set('g_dict', dict);

m_outside_g = PathLengthEnsemble('G', ge);
assert(isequal(m_outside_g.get('M'), known_pathlength), ...
    [BRAPH2.STR ':PathLengthEnsemble:' BRAPH2.BUG_ERR], ...
    'PathLengthEnsemble is not being calculated correctly for GraphBUEnsemble.')

m_inside_g = ge.getMeasure('PathLengthEnsemble');
assert(isequal(m_inside_g.get('M'), known_pathlength), ...
    [BRAPH2.STR ':PathLengthEnsemble:' BRAPH2.BUG_ERR], ...
    'PathLengthEnsemble is not being calculated correctly for GraphBUEnsemble.')

%%% ¡test!
%%%% ¡name!
MultiplexBUEnsemble
A11 = [
    0   .1  0   0
    .2  0   .1  0
    0   .1  0   .2
    0   0   .1  0
    ];

A22 = [
    0   .1  0   0
    .2  0   .1  0
    0   .1  0   .2
    0   0   .1  0
    ];

B = {A11 A22};

known_pathlength = {
    [2 4/3 4/3 2]'
    [2 4/3 4/3 2]'
    };

ge = MultiplexBUEnsemble();
dict = ge.get('G_DICT');
for i = 1:1:10
    g = MultiplexBU( ...
        'ID', ['g ' int2str(i)], ...
        'B', B ...
        );
    dict.add(g)
end
ge.set('g_dict', dict);
pathlength = PathLengthEnsemble('G', ge);

assert(isequal(pathlength.get('M'), known_pathlength), ...
    [BRAPH2.STR ':PathLengthEnsemble:' BRAPH2.BUG_ERR], ...
    'PathLengthEnsemble is not being calculated correctly for MultiplexBUEnsemble.')