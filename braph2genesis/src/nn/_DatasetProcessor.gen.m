%% ¡header!
DatasetProcessor < Element (dp, data processor of neural network model) produces the dataset that 
is prepared for training or testing neural netowrk model.  

%% ¡description!
This dataset processor produces the dataset that can be used to train a neural network model.
Feature selection procedure can be implemented.
Instances of this class should not be created. 
Use one of its subclasses instead.


%% ¡props!
%%% ¡prop!
ID (data, string) is a few-letter code for the graph analysis.

%%% ¡prop!
LABEL (metadata, string) is an extended label of the graph analysis.

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the graph analysis.
