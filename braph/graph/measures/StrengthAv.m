classdef StrengthAv < Strength
    methods
        function m = StrengthAv(g, varargin)
            
            settings = clean_varargin({}, varargin{:});
            
            m = m@Strength(g, settings{:});
        end
    end
    methods (Access=protected)
        function strength_av = calculate(m)
            
            g = m.getGraph();
            
            if g.is_measure_calculated('Strength')
                strength = g.getMeasureValue('Strength');
            else
                strength = calculate@Strength(m);
            end
            
            strength_av = mean(strength);
        end
    end
    methods(Static)
        function measure_class = getClass()
            measure_class = 'StrengthAv';
        end
        function name = getName()
            name = 'Average Strength';
        end
        function description = getDescription()
            description = [ ...
                'The average strength of a graph is ' ...
                'the average of the sum of the weights ' ...
                'of all edges connected to the node. ' ...
                ];
        end
        function bool = is_global()
            bool = true;
        end
        function bool = is_nodal()
            bool = false;
        end
        function bool = is_binodal()
            bool = false;
        end
        function list = getCompatibleGraphList()  
            list = { ...
                'GraphWU', ...
                };
        end
        function n = getCompatibleGraphNumber()
            n = Measure.getCompatibleGraphNumber('StrengthAv');
        end
    end
end