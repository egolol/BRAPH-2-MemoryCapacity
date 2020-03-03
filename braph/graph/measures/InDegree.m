classdef InDegree < Measure
    methods
        function m = InDegree(g, varargin)

            settings = clean_varargin({}, varargin{:});

            m = m@Measure(g, settings{:});
        end
    end
    methods(Access=protected)
        function in_degree = calculate(m)
            g = m.getGraph();
            A = g.getA();
            in_degree = sum(A, 1)';  % column sum of A
        end
    end
    methods (Static) 
         function measure_class = getClass()
            measure_class = 'InDegree';
        end
        function name = getName()
            name = 'In-Degree';
        end
        function description = getDescription()
            description = [ ...
                'The in-degree of a node is ' ...
                'the number of inward edges connected to the node. ' ...
                'Connection weights are ignored in calculations.' ...
                ];
        end
        function bool = is_global()
            bool = false;
        end
        function bool = is_nodal()
            bool = true;
        end
        function bool = is_binodal()
            bool = false;
        end
        function bool = is_compatible_graph(g)
            bool = g.is_directed();
        end
        function list = getCompatibleGraphList()  
            list = { ...
                'GraphBD', ...
                'GraphWD' ...
                };
        end
        function n = getCompatibleGraphNumber()
            n = Measure.getCompatibleGraphNumber('InDegree');
        end
    end
end