% eegplugin_SPA() - EEGLab plugin for simple and quick artifact rejection
% using SPA
% 
% Cite: Ouyang, G., Dien, J., & Lorenz, R. (2021). Handling EEG artifacts 
% and searching individually optimal experimental parameter in real time: 
% a system development and demonstration. Journal of Neural Engineering.
%
% Inputs:
%   fig           - [integer]  EEGLAB figure
%   try_strings   - [struct] "try" strings for menu callbacks.
%   catch_strings - [struct] "catch" strings for menu callbacks.
%

% Copyright (C) 2022  Guang Ouyang
% The University of Hong Kong
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA




function vers = eegplugin_SPA( fig,try_strings, catch_strings)

vers = 'SPA1.0';

toolsmenu = findobj(fig, 'tag', 'tools');
h = uimenu(toolsmenu, 'label', 'SPA', 'callback', ...
           [try_strings.no_check ...
           '[ALLEEG EEG CURRENTSET] = pop_SPA( ALLEEG ,EEG ,CURRENTSET );'...
           catch_strings.add_to_hist]); 