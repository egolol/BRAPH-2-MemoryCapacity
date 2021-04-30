% test BrainAtlas

br1 = BrainRegion('BR1', 'brain region 1', 'brain region notes 1', 1, 11, 111);
br2 = BrainRegion('BR2', 'brain region 2', 'brain region notes 2', 2, 22, 222);
br3 = BrainRegion('BR3', 'brain region 3', 'brain region notes 3', 3, 33, 333);
br4 = BrainRegion('BR4', 'brain region 4', 'brain region notes 4', 4, 44, 444);
br5 = BrainRegion('BR5', 'brain region 5', 'brain region notes 5', 5, 55, 555);
br6 = BrainRegion('BR6', 'brain region 6', 'brain region notes 6', 6, 66, 666);
br7 = BrainRegion('BR7', 'brain region 7', 'brain region notes 7', 7, 77, 777);
br8 = BrainRegion('BR8', 'brain region 8', 'brain region notes 8', 8, 88, 888);
br9 = BrainRegion('BR9', 'brain region 9', 'brain region notes 9', 9, 99, 999);

%% Test 1: Basic functions
atlas = BrainAtlas('TRIAL', 'Brain Atlas', 'Brain atlas notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

assert(ischar(atlas.tostring()), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_OUTPUT], ...
    'BrainAtlas.tostring() must return a string.')

%% Test 2: Get methods
id = 'TRIAL';
label = 'Brain Atlas';
notes = 'Brain atlas notes';
brain_regions = {br1, br2, br3, br4, br5};
atlas = BrainAtlas(id, label, notes, 'BrainMesh_ICBM152.nv', brain_regions);

assert(isequal(atlas.getID(), id), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_OUTPUT], ...
    'BrainAtlas.getID() does not work.')
assert(isequal(atlas.getLabel(), label), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_OUTPUT], ...
    'BrainAtlas.getLabel() does not work.')
assert(isequal(atlas.getNotes(), notes), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_OUTPUT], ...
    'BrainAtlas.getNotes() does not work.')
assert(isequal(atlas.getBrainRegions().getValues(), brain_regions), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_OUTPUT], ...
    'BrainAtlas.getBrainregions() does not work.')

%% Test 3: Set methods
atlas = BrainAtlas('TRIAL', 'Brain Atlas', 'Brain atlas notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

id = 'TRIAL UPDATED';
atlas.setID(id)
assert(isequal(atlas.getID(), id), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_FUNC], ...
    'BrainAtlas.setID() does not work.')

label = 'Brain Atlas UPDATED';
atlas.setLabel(label)
assert(isequal(atlas.getLabel(), label), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_FUNC], ...
    'BrainAtlas.setLabel() does not work.')

notes = 'Brain atlas notes UPDATED';
atlas.setNotes(notes)
assert(isequal(atlas.getNotes(), notes), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_FUNC], ...
    'BrainAtlas.setNotes() does not work.')

%% Test 4: Deep copy
id = 'TRIAL';
label = 'Brain Atlas';
notes = 'Brain atlas notes';
brain_regions = {br1, br2, br3, br4, br5};
atlas = BrainAtlas(id, label, notes, 'BrainMesh_ICBM152.nv', brain_regions);

atlas_copy = atlas.copy();
assert(isequal(atlas.getID(), atlas_copy.getID()) && ...
    isequal(atlas.getLabel(), atlas_copy.getLabel()) && ...
    isequal(atlas.getNotes(), atlas_copy.getNotes()) && ...
    isequal(atlas.getBrainRegions().length(), atlas_copy.getBrainRegions().length()), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_COPY], ...
    'BrainAtlas.copy() does not work.')

id_copy = 'BA COPY';
atlas_copy.setID(id_copy)
assert(isequal(atlas.getID(), id) && isequal(atlas_copy.getID(), id_copy), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_COPY], ...
    'BrainAtlas.copy() does not work.')

label_copy = 'Brain Atlas COPY';
atlas_copy.setLabel(label_copy)
assert(isequal(atlas.getLabel(), label) && isequal(atlas_copy.getLabel(), label_copy), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_COPY], ...
    'BrainAtlas.copy() does not work.')

notes_copy = 'Notes on brain atlas COPY.';
atlas_copy.setNotes(notes_copy)
assert(isequal(atlas.getNotes(), notes) && isequal(atlas_copy.getNotes(), notes_copy), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_COPY], ...
    'BrainAtlas.copy() does not work.')

atlas_copy.getBrainRegions().remove_all([1 3 5]);
atlas_copy.getBrainRegions().add(br6.getID(), br6)
atlas_copy.getBrainRegions().add(br7.getID(), br7)
atlas_copy.getBrainRegions().add(br8.getID(), br8)
atlas_copy.getBrainRegions().add(br9.getID(), br9)
assert(isequal(atlas.getBrainRegions().getValues(), {br1 br2 br3 br4 br5}) && ...
    isequal(atlas_copy.getBrainRegions().getValues(), {br2 br4 br6 br7 br8 br9}), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_COPY], ...
    'BrainAtlas.copy() does not work.')


%% Test 5: Save and load to XLS
br1 = BrainRegion('ISF', 'superiorfrontal', 'notes1', -12.6, 22.9, 42.4);
br2 = BrainRegion('lFP', 'frontalpole', 'notes2', -8.6,61.7,-8.7);
br3 = BrainRegion('lRMF', 'rostralmiddlefrontal', 'notes3', -31.3,41.2,16.5);
br4 = BrainRegion('lCMF', 'caudalmiddlefrontal', 'notes4', -34.6, 10.2, 42.8);
br5 = BrainRegion('lPOB', 'parsorbitalis', 'notes5', -41,38.8,-11.1);
atlas  = BrainAtlas('TestToSaveCoolName1', 'Brain Atlas', 'Brain atlas notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

file = [fileparts(which('test_braph2')) filesep 'trial_atlas_to_be_erased.xlsx'];

BrainAtlas.save_to_xls(atlas, 'File', file);

atlas_loaded = BrainAtlas.load_from_xls('File', file);

assert(isequal(atlas.getID(), atlas_loaded.getID()), ...
	'BRAPH:BrainAtlas:SaveLoadXLS', ...
    'Problems saving or loading a brain atlas.')
assert(isequal(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length()), ...
	'BRAPH:BrainAtlas:SaveLoadXLS', ...
    'Problems saving or loading a brain atlas.')
for i = 1:1:max(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length())
    br = atlas.getBrainRegions().getValue(i);
    br_loaded = atlas_loaded.getBrainRegions().getValue(i);    
    assert( ...
        isequal(br.getLabel(), br_loaded.getLabel()) & ...
        isequal(br.getID(), br_loaded.getID()) & ...
        isequal(br.getNotes(), br_loaded.getNotes()) & ...
        isequal(br.getX(), br_loaded.getX()) & ...
        isequal(br.getY(), br_loaded.getY()) & ...
        isequal(br.getZ(), br_loaded.getZ()), ...
        'BRAPH:BrainAtlas:SaveLoadXLS', ...
        'Problems saving or loading a brain atlas.')    
end

delete(file)

%% Test 6: Save and load to TXT
br1 = BrainRegion('ISF', 'superiorfrontal', 'notes1', -12.6, 22.9, 42.4);
br2 = BrainRegion('lFP', 'frontalpole', 'notes2', -8.6,61.7,-8.7);
br3 = BrainRegion('lRMF', 'rostralmiddlefrontal', 'notes3', -31.3,41.2,16.5);
br4 = BrainRegion('lCMF', 'caudalmiddlefrontal', 'notes4', -34.6, 10.2, 42.8);
br5 = BrainRegion('lPOB', 'parsorbitalis', 'notes5', -41,38.8,-11.1);
atlas  = BrainAtlas('TestToSaveCoolName1', 'Brain Atlas', 'Brain atlas notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

file = [fileparts(which('test_braph2')) filesep 'trial_atlas_to_be_erased.txt'];

BrainAtlas.save_to_txt(atlas, 'File', file);

atlas_loaded = BrainAtlas.load_from_txt('File', file);

assert(isequal(atlas.getID(), atlas_loaded.getID()), ...
	'BRAPH:BrainAtlas:SaveLoadTXT', ...
    'Problems saving or loading a brain atlas.')
assert(isequal(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length()), ...
	'BRAPH:BrainAtlas:SaveLoadTXT', ...
    'Problems saving or loading a brain atlas.')
for i = 1:1:max(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length())
    br = atlas.getBrainRegions().getValue(i);
    br_loaded = atlas_loaded.getBrainRegions().getValue(i);    
    assert( ...
        isequal(br.getLabel(), br_loaded.getLabel()) & ...
        isequal(br.getID(), br_loaded.getID()) & ...
        isequal(br.getNotes(), br_loaded.getNotes()) & ...
        isequal(br.getX(), br_loaded.getX()) & ...
        isequal(br.getY(), br_loaded.getY()) & ...
        isequal(br.getZ(), br_loaded.getZ()), ...
        'BRAPH:BrainAtlas:SaveLoadTXT', ...
        'Problems saving or loading a brain atlas.')    
end

delete(file)

%% Test 7: Save and load to JSON
br1 = BrainRegion('ISF', 'superiorfrontal', 'notes1', -12.6, 22.9, 42.4);
br2 = BrainRegion('lFP', 'frontalpole', 'notes2', -8.6,61.7,-8.7);
br3 = BrainRegion('lRMF', 'rostralmiddlefrontal', 'notes3', -31.3,41.2,16.5);
br4 = BrainRegion('lCMF', 'caudalmiddlefrontal', 'notes4', -34.6, 10.2, 42.8);
br5 = BrainRegion('lPOB', 'parsorbitalis', 'notes5', -41,38.8,-11.1);
atlas  = BrainAtlas('TestToSaveCoolName1', 'Brain Atlas', 'Brain atlas notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

file = [fileparts(which('test_braph2')) filesep 'trial_atlas_to_be_erased.json'];

JSON.Serialize(BrainAtlas.save_to_json(atlas), 'File', file);

atlas_loaded = BrainAtlas.load_from_json('File', file);

assert(isequal(atlas.getID(), atlas_loaded.getID()), ...
	'BRAPH:BrainAtlas:SaveLoadJSON', ...
    'Problems saving or loading a brain atlas.')
assert(isequal(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length()), ...
	'BRAPH:BrainAtlas:SaveLoadJSON', ...
    'Problems saving or loading a brain atlas.')
for i = 1:1:max(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length())
    br = atlas.getBrainRegions().getValue(i);
    br_loaded = atlas_loaded.getBrainRegions().getValue(i);    
    assert( ...
        isequal(br.getLabel(), br_loaded.getLabel()) & ...
        isequal(br.getID(), br_loaded.getID()) & ...
        isequal(br.getX(), br_loaded.getX()) & ...
        isequal(br.getY(), br_loaded.getY()) & ...
        isequal(br.getZ(), br_loaded.getZ()), ...
        'BRAPH:BrainAtlas:SaveLoadJSON', ...
        'Problems saving or loading a brain atlas.')    
end

delete(file)

%% Test 8: Plot testing
brain_surf = 'BrainMesh_Cerebellum.nv';
atlas = BrainAtlas('', '', '', brain_surf, {});
ba = atlas.getPlotBrainAtlas();

assert(~isempty(ba), ...
	'BRAPH:BrainAtlas:Plot', ...
    'Problems ploting brain atlas surface.')