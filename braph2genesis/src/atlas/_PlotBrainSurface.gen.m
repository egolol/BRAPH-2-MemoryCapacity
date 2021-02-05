%% ¡header!
PlotBrainSurface < Plot (pl, plot brain surface) is a plot of a brain surfce.

%%% ¡description!
PlotBrainSurface manages the brain surface choosen by the user. 
A collection of brain surfaces in NV format can be found in the folder 
./braph2/brainsurfs/.
This class provides the common methods needed to manage the plot of 
the surface, via a custom panel called ''Brain Surface Settings'' where
the user can change lighting, material, camlight, shadning, colormap,
facecolor, brain color, face color, edge color, and background color. 

%%% ¡seealso!
Plot, BrainSurface

%% ¡constants!
% fixed 3d view
VIEW_3D	= 1 % 3D view numeric code
VIEW_3D_CMD = '3D' % 3D view name
VIEW_3D_AZEL = [-37.5 30] % 3D view azimutal and polar angles

% sagittal left view
VIEW_SL	= 2 % sagittal left view numeric code
VIEW_SL_CMD = 'Sagittal left' % sagittal left view name
VIEW_SL_AZEL = [-90 0] % sagittal left view azimutal and polar angles

% sagittal right view
VIEW_SR	= 3 % sagittal right view numeric code
VIEW_SR_CMD = 'Sagittal right' % sagittal right view name
VIEW_SR_AZEL = [90 0] % sagittal right view azimutal and polar angles 

% axial dorsal view
VIEW_AD = 4 % axial dorsal view numeric code
VIEW_AD_CMD = 'Axial dorsal' % axial dorsal view name
VIEW_AD_AZEL = [0 90] % axial dorsal view azimutal and polar angles

% axial ventral view
VIEW_AV = 5 % axial ventral view numeric code
VIEW_AV_CMD = 'Axial ventral' % axial ventral view name
VIEW_AV_AZEL = [0 -90] % axial ventral view azimutal and polar angles

% coronal anterior view
VIEW_CA = 6 % coronal anterior view numeric code
VIEW_CA_CMD = 'Coronal anterior' % coronal anterior view name
VIEW_CA_AZEL = [180 0] % coronal anterior view azimutal and polar angles

% coronal posterior view
VIEW_CP = 7 % coronal posterior view numeric code
VIEW_CP_CMD = 'Coronal posterior' % coronal posterior view name
VIEW_CP_AZEL = [0 0] % coronal posterior view azimutal and polar angles

VIEW_CMD = { ... % vector of view names
    PlotBrainSurface.VIEW_3D_CMD ...
    PlotBrainSurface.VIEW_SL_CMD ...
    PlotBrainSurface.VIEW_SR_CMD ...
    PlotBrainSurface.VIEW_AD_CMD ...
    PlotBrainSurface.VIEW_AV_CMD ...
    PlotBrainSurface.VIEW_CA_CMD ...
    PlotBrainSurface.VIEW_CP_CMD ...
    }

VIEW_AZEL = { ... % vector of view azimutal and polar angle
    PlotBrainSurface.VIEW_3D_AZEL ...
    PlotBrainSurface.VIEW_SL_AZEL ...
    PlotBrainSurface.VIEW_SR_AZEL ...
    PlotBrainSurface.VIEW_AD_AZEL ...
    PlotBrainSurface.VIEW_AV_AZEL ...
    PlotBrainSurface.VIEW_CA_AZEL ...
    PlotBrainSurface.VIEW_CP_AZEL ...
    }

%% ¡properties!
h_axes % handle for the axes
h_brain % handle for brain surface

%% ¡props!

%%% ¡prop!
SURF (metadata, item) is the brain surface to be plotted.
%%%% ¡settings!
'BrainSurface'

%%% ¡prop!
VIEW (metadata, rvector) sets the desired view.
%%%% ¡check_prop!
check = length(value) == 2;
%%%% ¡default!
PlotBrainSurface.VIEW_3D_AZEL

%%% ¡prop!
HOLD (metadata, logical) determines whether hold is on or offf.
%%%% ¡default!
true

%%% ¡prop!
GRID (metadata, logical) determines whether the grid is shown.
%%%% ¡default!
true

%%% ¡prop!
AXIS (metadata, logical) determines whether the axis is shown.
%%%% ¡default!
true

%%% ¡prop!
EQUAL (metadata, logical) determines whether the axis are equal.
%%%% ¡default!
true

%%% ¡prop!
TIGHT (metadata, logical) determines whether the axis are tight.
%%%% ¡default!
false

%%% ¡prop!
BRAIN (metadata, logical) determines whether the brain surface is shown.
%%%% ¡default!
true

%%% ¡prop!
EDGECOLOR (metadata, rvector) is the RGB edge color.
%%%% ¡check_prop!
check = (length(value) == 3) && all(value >= 0 & value <= 1);
%%%% ¡default!
[1 1 1]

%%% ¡prop!
EDGEALPHA (metadata, scalar) is the edge transparency.
%%%% ¡check_prop!
check = value >= 0 && value <= 1;
%%%% ¡default!
0

%%% ¡prop!
FACECOLOR (metadata, rvector) is the RGB face color.
%%%% ¡check_prop!
check = (length(value) == 3) && all(value >= 0 & value <= 1);
%%%% ¡default!
[.5 .5 .5]

%%% ¡prop!
FACEALPHA (metadata, scalar) is the face transparency.
%%%% ¡check_prop!
check = value >= 0 && value <= 1;
%%%% ¡default!
.5

%%% ¡prop!
LIGHTING (metadata, option) is the lighting value.
%%%% ¡settings!
{'phong' 'none' 'flat' 'gouraud'}

%%% ¡prop!
MATERIAL (metadata, option) is the material value.
%%%% ¡settings!
{'shiny' 'dull' 'metal'}

%%% ¡prop!
CAMLIGHT (metadata, option) is the camlight value.
%%%% ¡settings!
{'headlight' 'right' 'left'}

%%% ¡prop!
SHADING (metadata, option) is the shading value.
%%%% ¡settings!
{'interp' 'none' 'flat' 'faceted'}

%%% ¡prop!
COLORMAP (metadata, matrix) is the colormap.
%%%% ¡check_prop!
check = size(value, 2) == 3;
%%%% ¡default!
jet
        
%% ¡methods!
function h_panel = draw(pl, varargin)
    %DRAW draws the brain surface graphical panel.
    %
    % DRAW(PL) draws the brain surface graphical panel.
    %
    % H = DRAW(PL) returns a handle to the brain surface graphical panel.
    %
    % DRAW(PL, 'Property', VALUE, ...) sets the properties of the graphical
    %  panel with custom property-value couples.
    %  All standard plot properties of uipanel can be used.
    %
    % It is possible to access the properties of the various graphical
    %  objects from the handle to the brain surface graphical panel H.
    %
    % see also settings, uipanel, isgraphics.

    h = draw@Plot(pl, varargin{:});

    % axes
    if isempty(pl.h_axes) || ~isgraphics(pl.h_axes, 'axes')
        pl.h_axes = axes(h);
    end
    set(pl.h_axes, 'Color', pl.get('BKGCOLOR'))
    
    % brain
    if pl.get('BRAIN')
        if isempty(pl.h_brain) || ~isgraphics(pl.h_brain, 'patch')
            triangles = pl.get('SURF').get('TRIANGLES');
            coordinates = pl.get('SURF').get('COORDINATES');
            pl.h_brain = trisurf( ...
                triangles, ...
                coordinates(1, :), ...
                coordinates(2, :), ...
                coordinates(3, :), ...
                'Parent', pl.h_axes ...
                );
        end
        set(pl.h_brain, ...
            'Visible', 'on', ...
            'EdgeColor', pl.get('EDGECOLOR'), ...
            'EdgeAlpha', pl.get('EDGEALPHA'), ...
            'FaceColor', pl.get('FACECOLOR'), ...
            'FaceAlpha', pl.get('FACEALPHA') ...
            )
        lighting(pl.h_axes, pl.get('LIGHTING'))

        material(pl.h_axes, pl.get('MATERIAL'))

        delete(findall(pl.h_axes, 'Type', 'light'));
        camlight(pl.h_axes, pl.get('CAMLIGHT'))

        shading(pl.h_axes, pl.get('SHADING'))
        
        colormap(pl.h_axes, pl.get('COLORMAP'))
    else
        if ~isempty(pl.h_brain) && isgraphics(pl.h_brain, 'patch')
            set(pl.h_brain, 'Visible', 'off')
        end
    end
    
    % plot settings
    view(pl.h_axes, pl.get('VIEW'))
    
    if pl.get('HOLD')
        hold(pl.h_axes, 'on')
    else
        hold(pl.h_axes, 'off')
    end

    if pl.get('GRID')
        grid(pl.h_axes, 'on')
    else
        grid(pl.h_axes, 'off')
    end

    if pl.get('AXIS')
        axis(pl.h_axes, 'on')
    else
        axis(pl.h_axes, 'off')
    end
    
    if pl.get('EQUAL')
        daspect(pl.h_axes, [1 1 1])
    end
    
    if pl.get('TIGHT')
        axis(pl.h_axes, 'tight')
    end
    
    % output
    if nargout > 0
        h_panel = h;
    end
end
function f_settings = settings(pl, varargin)
    %SETTINGS opens the brain surface property editor GUI.
    %
    % SETTINGS(PL) allows the user to specify the properties of the brain
    %  surface plot by opening a GUI property editor.
    %
    % F = SETTINGS(PL) returns a handle to the property editor GUI.
    %
    % See also draw, figure, isgraphics.

    f = settings@Plot(pl, varargin{:})

    % background color
    ui_button_backgroundcolor = uicontrol(f, 'Style', 'pushbutton', ...
        'Units','normalized', ...
        'Position', [.05 .80 .20 .20], ...
        'String', 'background color', ...
        'HorizontalAlignment', 'center', ...
        'TooltipString', 'Image background color', ...
        'Callback', {@cb_backgroundcolor})
    function cb_backgroundcolor(~, ~) % (src, event)
        color = uisetcolor;
        if length(color) == 3
            pl.set('BKGCOLOR', color)
            pl.draw()
        end
    end

% %     % brain color and transparency
% %     ui_text_transparency = uicontrol(f, 'Style', 'text');
% %     set(ui_text_transparency, 'Units', 'normalized')
% %     set(ui_text_transparency, 'BackgroundColor', FigColor)
% %     set(ui_text_transparency, 'String', 'transparency')
% %     set(ui_text_transparency, 'Position', [.25 .60 .35 .20])
% %     set(ui_text_transparency, 'HorizontalAlignment', 'center')
% %     set(ui_text_transparency, 'FontWeight', 'bold')
% % 
% %     ui_button_color = uicontrol(f, 'Style', 'pushbutton');
% %     set(ui_button_color, 'Units', 'normalized')
% %     set(ui_button_color, 'Position', [.05 .50 .15 .20])
% %     set(ui_button_color, 'String', 'brain color')
% %     set(ui_button_color, 'HorizontalAlignment', 'center')
% %     set(ui_button_color, 'TooltipString', 'Brain surface color (applied both to faces and edges)')
% %     set(ui_button_color, 'Callback', {@cb_color})
% % 
% %     ui_slider_alpha = uicontrol(f, 'Style', 'slider');
% %     set(ui_slider_alpha, 'Units', 'normalized')
% %     set(ui_slider_alpha, 'BackgroundColor', FigColor)
% %     set(ui_slider_alpha, 'Position', [.25 .50 .35 .15])
% %     set(ui_slider_alpha, 'String', 'Brain transparency')
% %     set(ui_slider_alpha, 'Min', 0, 'Max', 1, 'Value', max(get(bs.brain, 'FaceAlpha'), get(bs.brain, 'EdgeAlpha')))
% %     set(ui_slider_alpha, 'TooltipString', 'Brain surface transparency (applied both to faces and edges)')
% %     set(ui_slider_alpha, 'Callback', {@cb_alpha})
% % 
% %     ui_button_facecolor = uicontrol(f, 'Style', 'pushbutton');
% %     set(ui_button_facecolor, 'Units', 'normalized')
% %     set(ui_button_facecolor, 'Position', [.05 .30 .15 .20])
% %     set(ui_button_facecolor, 'String', 'face color')
% %     set(ui_button_facecolor, 'HorizontalAlignment', 'center')
% %     set(ui_button_facecolor, 'TooltipString', 'Brain surface face color')
% %     set(ui_button_facecolor, 'Callback', {@cb_facecolor})
% % 
% %     ui_slider_facealpha = uicontrol(f, 'Style', 'slider');
% %     set(ui_slider_facealpha, 'Units', 'normalized')
% %     set(ui_slider_facealpha, 'BackgroundColor', FigColor)
% %     set(ui_slider_facealpha, 'Position', [.25 .30 .35 .15])
% %     set(ui_slider_facealpha, 'String', 'Brain transparency')
% %     set(ui_slider_facealpha, 'Min', 0, 'Max', 1, 'Value', get(bs.brain,'FaceAlpha'))
% %     set(ui_slider_facealpha, 'TooltipString', 'Brain surface face transparency')
% %     set(ui_slider_facealpha, 'Callback', {@cb_facealpha})
% % 
% %     ui_button_edgecolor = uicontrol(f, 'Style', 'pushbutton');
% %     set(ui_button_edgecolor, 'Units', 'normalized')
% %     set(ui_button_edgecolor, 'Position', [.05 .10 .15 .20])
% %     set(ui_button_edgecolor, 'String', 'edge color')
% %     set(ui_button_edgecolor, 'HorizontalAlignment', 'center')
% %     set(ui_button_edgecolor, 'TooltipString', 'Brain surface edge color')
% %     set(ui_button_edgecolor, 'Callback', {@cb_edgecolor})
% % 
% %     ui_slider_edgealpha = uicontrol(f, 'Style', 'slider');
% %     set(ui_slider_edgealpha, 'Units', 'normalized')
% %     set(ui_slider_edgealpha, 'BackgroundColor', FigColor)
% %     set(ui_slider_edgealpha, 'Position', [.25 .10 .35 .15])
% %     set(ui_slider_edgealpha, 'String', 'Brain transparency')
% %     set(ui_slider_edgealpha, 'Min', 0, 'Max', 1, 'Value', get(bs.brain, 'EdgeAlpha'))
% %     set(ui_slider_edgealpha, 'TooltipString', 'Brain surface edge transparency')
% %     set(ui_slider_edgealpha, 'Callback', {@cb_edgealpha})
% % 
% %     function cb_color(~, ~)  % (src, event)
% %         color = uisetcolor;
% %         if length(color) == 3
% %             bs.brain('Color', color)
% %         end
% %     end
% %     function cb_alpha(~, ~)  % (src, event)
% %         bs.brain('Alpha', get(ui_slider_alpha, 'Value'))
% %         set(ui_slider_facealpha, 'Value', get(ui_slider_alpha, 'Value'))
% %         set(ui_slider_edgealpha, 'Value', get(ui_slider_alpha, 'Value'))
% %     end
% %     function cb_facecolor(~, ~)  % (src, event)
% %         color = uisetcolor;
% %         if length(color) == 3
% %             bs.brain('FaceColor', color)
% %         end
% %     end
% %     function cb_facealpha(~, ~)  % (src, event)
% %         bs.brain('FaceAlpha', get(ui_slider_facealpha, 'Value'))
% %     end
% %     function cb_edgecolor(~, ~)  % (src, event)
% %         color = uisetcolor;
% %         if length(color) == 3
% %             bs.brain('EdgeColor', color)
% %         end
% %     end
% %     function cb_edgealpha(~, ~)  % (src, event)
% %         bs.brain('EdgeAlpha', get(ui_slider_edgealpha, 'Value'))
% %     end
% % 
% %     % lightining
% %     ui_text_lighting = uicontrol(f, 'Style', 'text');
% %     set(ui_text_lighting, 'Units','normalized')
% %     set(ui_text_lighting, 'BackgroundColor', FigColor)
% %     set(ui_text_lighting, 'String', 'lighting')
% %     set(ui_text_lighting, 'Position', [.65 .70 .10 .15])
% %     set(ui_text_lighting, 'HorizontalAlignment', 'center')
% %     set(ui_text_lighting, 'FontWeight', 'bold')
% % 
% %     ui_popup_lighting = uicontrol(f, 'Style', 'popupmenu');
% %     set(ui_popup_lighting, 'Units', 'normalized')
% %     set(ui_popup_lighting, 'Position', [.75 .70 .20 .15])
% %     set(ui_popup_lighting, 'String', {'none', 'flat', 'phong', 'gouraud'})
% %     set(ui_popup_lighting, 'Value', find(strcmpi(bs.Lighting, get(ui_popup_lighting, 'String'))))
% %     set(ui_popup_lighting, 'HorizontalAlignment', 'center')
% %     set(ui_popup_lighting, 'Callback', {@cb_lighting})
% % 
% %     function cb_lighting(~, ~)  % (src, event)
% %         val = ui_popup_lighting.Value;
% %         str = ui_popup_lighting.String;
% %         bs.lighting(str{val});
% %     end
% % 
% %     % material
% %     ui_text_material = uicontrol(f, 'Style', 'text');
% %     set(ui_text_material, 'Units', 'normalized')
% %     set(ui_text_material, 'BackgroundColor', FigColor)
% %     set(ui_text_material, 'String', 'material')
% %     set(ui_text_material, 'Position', [.65 .55 .10 .15])
% %     set(ui_text_material, 'HorizontalAlignment', 'center')
% %     set(ui_text_material, 'FontWeight', 'bold')            
% % 
% %     ui_popup_material = uicontrol(f, 'Style', 'popupmenu');
% %     set(ui_popup_material, 'Units', 'normalized')
% %     set(ui_popup_material, 'Position', [.75 .55 .20 .15])
% %     set(ui_popup_material, 'String', {'dull', 'shiny', 'metal'})
% %     set(ui_popup_material, 'Value', find(strcmpi(bs.Material, get(ui_popup_material, 'String'))))
% %     set(ui_popup_material, 'HorizontalAlignment', 'center')
% %     set(ui_popup_material, 'Callback', {@cb_material})
% % 
% %     function cb_material(~, ~)  % (src, event)
% %         val = ui_popup_material.Value;
% %         str = ui_popup_material.String;
% %         bs.material(str{val});
% %     end
% % 
% %     % camlight
% %     ui_text_camlight = uicontrol(f, 'Style', 'text');
% %     set(ui_text_camlight, 'Units', 'normalized')
% %     set(ui_text_camlight, 'BackgroundColor', FigColor)
% %     set(ui_text_camlight, 'String', 'camlight')
% %     set(ui_text_camlight, 'Position', [.65 .40 .10 .15])
% %     set(ui_text_camlight, 'HorizontalAlignment', 'center')
% %     set(ui_text_camlight, 'FontWeight', 'bold') 
% % 
% %     ui_popup_camlight = uicontrol(f, 'Style', 'popupmenu');
% %     set(ui_popup_camlight, 'Units', 'normalized')
% %     set(ui_popup_camlight, 'Position', [.75 .40 .20 .15])
% %     set(ui_popup_camlight, 'String', {'headlight', 'right', 'left'})
% %     set(ui_popup_camlight, 'Value', find(strcmpi(bs.CamLight, get(ui_popup_camlight, 'String'))))
% %     set(ui_popup_camlight, 'HorizontalAlignment', 'center')
% %     set(ui_popup_camlight, 'Callback', {@cb_camlight})
% % 
% %     function cb_camlight(~, ~)  % (src, event)
% %         val = ui_popup_camlight.Value;
% %         str = ui_popup_camlight.String;
% %         bs.camlight(str{val});
% %     end
% % 
% %     % shading
% %     ui_text_shading = uicontrol(f, 'Style', 'text');
% %     set(ui_text_shading, 'Units', 'normalized')
% %     set(ui_text_shading, 'BackgroundColor', FigColor)
% %     set(ui_text_shading, 'String', 'shading')
% %     set(ui_text_shading, 'Position', [.65 .25 .10 .15])
% %     set(ui_text_shading, 'HorizontalAlignment', 'center')
% %     set(ui_text_shading, 'FontWeight', 'bold') 
% % 
% %     ui_popup_shading = uicontrol(f, 'Style', 'popupmenu');
% %     set(ui_popup_shading, 'Units', 'normalized')
% %     set(ui_popup_shading, 'Position', [.75 .25 .20 .15])
% %     set(ui_popup_shading, 'String', {'flat', 'faceted', 'interp'})
% %     set(ui_popup_shading, 'Value', find(strcmpi(bs.Shading, get(ui_popup_shading, 'String'))))
% %     set(ui_popup_shading, 'HorizontalAlignment', 'center')
% %     set(ui_popup_shading, 'Callback', {@cb_shading})
% % 
% %     function cb_shading(~, ~)  % (src, event)
% %         val = ui_popup_shading.Value;
% %         str = ui_popup_shading.String;
% %         bs.shading(str{val});
% %     end
% % 
% %     % colormap
% %     ui_text_colormap = uicontrol(f, 'Style', 'text');
% %     set(ui_text_colormap, 'Units', 'normalized')
% %     set(ui_text_colormap, 'BackgroundColor', FigColor)
% %     set(ui_text_colormap, 'String', 'colormap')
% %     set(ui_text_colormap, 'Position', [.65 .10 .10 .15])
% %     set(ui_text_colormap, 'HorizontalAlignment', 'center')
% %     set(ui_text_colormap, 'FontWeight', 'bold') 
% % 
% %     ui_popup_colormap = uicontrol(f, 'Style', 'popupmenu');
% %     set(ui_popup_colormap, 'Units', 'normalized')
% %     set(ui_popup_colormap, 'Position', [.75 .10 .20 .15])
% %     set(ui_popup_colormap, 'String', {'parula', 'jet', 'hsv', 'hot', ...
% %         'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', ...
% %         'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'white'})
% %     set(ui_popup_colormap, 'Value', find(strcmpi(bs.Colormap, get(ui_popup_colormap, 'String'))))
% %     set(ui_popup_colormap, 'HorizontalAlignment', 'center')
% %     set(ui_popup_colormap, 'Callback', {@cb_colormap})
% % 
% %     function cb_colormap(~, ~)  % (src, event)
% %         val = ui_popup_colormap.Value;
% %         str = ui_popup_colormap.String;
% %         bs.colormap(str{val});
% %     end

    % output
    if nargout > 0
        f_settings = f;
    end
end

%% ¡tests!

%%% ¡test!
%%%% ¡name!
Basics
%%%% ¡code!
fig = figure();

pl = PlotBrainSurface('SURF', ImporterBrainSurfaceNV('FILE', 'human_ICBM152.nv').get('SURF'));
pl.draw('Units', 'normalized', 'Position', [.1 .1 .8 .8]);

pl.set('FACECOLOR', [1 0 0 ])
pl.draw()

pl.set('BRAIN', false)
pl.draw()

pl.set('BRAIN', true)
pl.draw()

pl.settings()

pl.set('GRID', false)
pl.draw()

pl.set('GRID', true)
pl.draw()

pl.set('AXIS', false)
pl.draw()

pl.set('EQUAL', true)
pl.draw()

pl.set('TIGHT', true)
pl.draw()

pl.set('view', [45 45])
pl.draw()

pl.set(...
    'LIGHTING', 'phong', ...
    'MATERIAL', 'shiny', ...
    'CAMLIGHT', 'left', ...
    'SHADING', 'interp', ...
    'COLORMAP', autumn)
pl.draw()

close(pl.settings())
close(fig)