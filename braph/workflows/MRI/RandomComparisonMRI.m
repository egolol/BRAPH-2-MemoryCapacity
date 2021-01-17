classdef RandomComparisonMRI < RandomComparison
    properties
        measure_code  % class of measure
        value_group  % array with the value_group of the measure for each subject of group 1
        value_random  % array with the value_group of the measure for each subject of group 1
        difference  % difference
        all_differences  % all differences obtained through the permutation test
        p1  % p value single tailed
        p2  % p value double tailed
        confidence_interval_min  % min value of the 95% confidence interval
        confidence_interval_max  % max value of the 95% confidence interval
    end
    methods
        function c =  RandomComparisonMRI(id, atlas, group, varargin)
            c = c@RandomComparison(id, atlas, group, varargin{:});
        end
        function measure_code = getMeasureCode(c)
            measure_code = c.measure_code;
        end
        function value = getGroupValue(c)
            value = c.value_group;
        end
        function random_value = getRandomValue(c)
            random_value = c.value_random;
        end
        function difference = getDifference(c)
            difference = c.difference;
        end
        function all_differences = getAllDifferences(c)
            all_differences = c.all_differences;
        end
        function p1 = getP1(c)
            p1 = c.p1;
        end
        function p2 = getP2(c)
            p2 = c.p2;
        end
        function confidence_interval_min = getConfidenceIntervalMin(c)
            confidence_interval_min = c.confidence_interval_min;
        end
        function confidence_interval_max = getConfidenceIntervalMax(c)
            confidence_interval_max = c.confidence_interval_max;
        end
    end
    methods (Access=protected)
        function initialize_data(c, varargin)
            atlases = c.getBrainAtlases();
            atlas = atlases{1};       
            
            c.measure_code = get_from_varargin('Degree', ...
                'RandomComparisonMRI.measure_code', ...
                varargin{:});
            number_of_permutations = get_from_varargin(1, ...
                'RandomComparisonMRI.number_of_permutations', ...
                varargin{:});
            
            if Measure.is_global(c.getMeasureCode())  % global measure
                % values
                c.value_group = get_from_varargin( ...
                    repmat({0}, 1, 1), ...
                    'RandomComparisonMRI.value_group', ...
                    varargin{:});
                c.value_random = get_from_varargin( ...
                    repmat({0}, 1, 1), ...
                    'RandomComparisonMRI.value_random', ...
                    varargin{:});
                assert(iscell(c.getGroupValue()) & ...
                    isequal(size(c.getGroupValue()), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupValue())), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])  %#ok<*NBRAK>
                assert(iscell(c.getRandomValue()) & ...
                    isequal(size(c.getRandomValue()), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getRandomValue())), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                
                % permutation measures
                 c.difference = get_from_varargin( ...
                    0, ...
                    'RandomComparisonMRI.difference', ...
                    varargin{:});
                c.all_differences = get_from_varargin( ...
                    repmat({0}, 1, number_of_permutations), ...
                    'RandomComparisonMRI.all_differences', ...
                    varargin{:});
                c.p1 = get_from_varargin( ...
                    0, ...
                    'RandomComparisonMRI.p1', ...
                    varargin{:});
                c.p2 = get_from_varargin( ...
                    0, ...
                    'RandomComparisonMRI.p2', ...
                    varargin{:});
                c.confidence_interval_min = get_from_varargin( ...
                    0, ...
                    'RandomComparisonMRI.confidence_min', ...
                    varargin{:});
                c.confidence_interval_max = get_from_varargin( ...
                    0, ...
                    'RandomComparisonMRI.confidence_max', ...
                    varargin{:});
                
                assert(isequal(size(c.getDifference()), [1, 1]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getAllDifferences()), [1, number_of_permutations]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getP1()), [1, 1]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getP2()), [1, 1]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                
            elseif Measure.is_nodal(c.getMeasureCode())  % nodal measure
                c.value_group = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, 1), ...
                    'RandomComparisonMRI.value_group', ...
                    varargin{:});
                c.value_random = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, 1), ...
                    'RandomComparisonMRI.value_random', ...
                    varargin{:});
                assert(iscell(c.getGroupValue()) & ...
                    isequal(size(c.getGroupValue()), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupValue())), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(iscell(c.getRandomValue()) & ...
                    isequal(size(c.getRandomValue()), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getRandomValue())), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                
                % statistic values
               c.difference = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'RandomComparisonMRI.difference', ...
                    varargin{:});
                c.all_differences = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, number_of_permutations), ...
                    'RandomComparisonMRI.all_differences', ...
                    varargin{:});
                c.p1 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'RandomComparisonMRI.p1', ...
                    varargin{:});
                c.p2 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'RandomComparisonMRI.p2', ...
                    varargin{:});
                c.confidence_interval_min = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'RandomComparisonMRI.confidence_min', ...
                    varargin{:});
                c.confidence_interval_max = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'RandomComparisonMRI.confidence_max', ...
                    varargin{:});
                
                assert(isequal(size(c.getDifference()), [atlas.getBrainRegions().length(), 1]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getAllDifferences()), [1, number_of_permutations]), ...  % it should be like this currently the second dimension is expanding depending on modality.
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getP1()), [atlas.getBrainRegions().length(), 1]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getP2()), [atlas.getBrainRegions().length(), 1]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getConfidenceIntervalMin()), [atlas.getBrainRegions().length(), 1]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getConfidenceIntervalMax()), [atlas.getBrainRegions().length(), 1]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                
            elseif Measure.is_binodal(c.getMeasureCode())  % binodal measure
                c.value_group = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, 1), ...
                    'RandomComparisonMRI.value_group', ...
                    varargin{:});
                c.value_random = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, 1), ...
                    'RandomComparisonMRI.value_random', ...
                    varargin{:});
                assert(iscell(c.getGroupValue()) & ...
                    isequal(size(c.getGroupValue()), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupValue())), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(iscell(c.getRandomValue()) & ...
                    isequal(size(c.getRandomValue()), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getRandomValue())), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                
                % statistic values
                 c.difference = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'RandomComparisonMRI.difference', ...
                    varargin{:});
                c.all_differences = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, number_of_permutations), ...
                    'RandomComparisonMRI.all_differences', ...
                    varargin{:});
                c.p1 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'RandomComparisonMRI.p1', ...
                    varargin{:});
                c.p2 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'RandomComparisonMRI.p2', ...
                    varargin{:});
                c.confidence_interval_min = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'RandomComparisonMRI.confidence_min', ...
                    varargin{:});
                c.confidence_interval_max = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'RandomComparisonMRI.confidence_max', ...
                    varargin{:});
                
                assert(isequal(size(c.getDifference()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getAllDifferences()), [1, number_of_permutations]), ...  % it should be like this currently the second dimension is expanding depending on modality.
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getP1()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getP2()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getConfidenceIntervalMin()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
                assert(isequal(size(c.getConfidenceIntervalMax()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    ['BRAPH:RandomComparisonMRI:WrongData'], ...
                    ['Data not compatible with RandomComparisonMRI.'])
            end
        end
    end
    methods (Static)
        function measurement_class = getClass(c) %#ok<*INUSD>
            measurement_class = 'RandomComparisonMRI';
        end
        function name = getName(c)
            name = 'RandomComparison MRI';
        end
        function description = getDescription(c)
            % comparison description missing
            description = '';
        end
        function analysis_class = getAnalysisClass(c)
            analysis_class = 'AnalysisMRI';
        end
        function subject_class = getSubjectClass(c)
            subject_class = 'SubjectMRI';
        end
        function atlas_number = getBrainAtlasNumber(c)
            atlas_number =  1;
        end
        function sub = getComparison(comparisonClass, id, atlas, group, varargin)
            sub = eval([comparisonClass '(id, atlas, group, varargin{:})']);
        end
    end
end