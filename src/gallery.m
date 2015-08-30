function  gallery(opt)
%	$Id$
%	The examples Gallery in GMT-MEX API
%

global g_root_dir out_path;
% Edit those two for your own needs
g_root_dir = 'C:/progs_cygw/GMTdev/gmt5/branches/5.2.0/';
out_path = 'V:/';		% Set this if you want to save the PS files in a prticular place

	all_exs = {'ex01' 'ex02' 'ex04' 'ex06' 'ex07' 'ex08' 'ex09' 'ex10' 'ex23' 'ex44'}; 

	if (nargin == 0)
		opt = all_exs;
	else
		opt = {opt};		% Make it a cell to fit the other branch
	end

	try
		for (k = 1: numel(opt))
			switch opt{k}
				case 'ex01',   ex01
				case 'ex02',   ex02
				case 'ex04',   ex04
				case 'ex06',   ex06
				case 'ex07',   ex07
				case 'ex08',   ex08
				case 'ex09',   ex09
				case 'ex10',   ex10
				case 'ex23',   ex23
				case 'ex44',   ex44
			end
		end
	catch
		sprintf('Error in test: %s\n%s', opt{k}, lasterr)
	end

	gmt('destroy')

% -------------------------------------------------------------------------------------------------
function ex01()
	global g_root_dir out_path
	d_path = [g_root_dir 'doc/examples/ex01'];
	ps = [out_path 'example_01.ps'];

	gmt('gmtset MAP_GRID_CROSS_SIZE_PRIMARY 0 FONT_ANNOT_PRIMARY 10p')
	gmt(['psbasemap -R0/6.5/0/7.5 -Jx1i -B0 -P -K > ' ps])
	gmt(['pscoast -Rg -JH0/6i -X0.25i -Y0.2i -O -K -Bg30 -Dc -Glightbrown -Slightblue >> ' ps])
	cmd = sprintf('grdcontour %s/osu91a1f_16.nc', d_path);
	gmt([cmd ' -J -C10 -A50+f7p -Gd4i -L-1000/-1 -Wcthinnest,- -Wathin,- -O -K -T+d0.1i/0.02i >> ' ps])
	gmt([cmd ' -J -C10 -A50+f7p -Gd4i -L-1/1000 -O -K -T+d0.1i/0.02i >> ' ps])
	gmt(['pscoast -Rg -JH6i -Y3.4i -O -K -B+t"Low Order Geoid" -Bg30 -Dc -Glightbrown -Slightblue >> ' ps])
	gmt([cmd ' -J -C10 -A50+f7p -Gd4i -L-1000/-1 -Wcthinnest,- -Wathin,- -O -K -T+d0.1i/0.02i+l >> ' ps])
	gmt([cmd ' -J -C10 -A50+f7p -Gd4i -L-1/1000 -O -T+d0.1i/0.02i+l >> ' ps])
	builtin('delete','gmt.conf');

% -------------------------------------------------------------------------------------------------
function ex02()
	global g_root_dir out_path
	d_path = [g_root_dir 'doc/examples/ex02'];
	ps = [out_path 'example_02.ps'];

	gmt('gmtset FONT_TITLE 30p MAP_ANNOT_OBLIQUE 0')
	g_cpt = gmt('makecpt -Crainbow -T-2/14/2');
	cmd = sprintf('grdimage %s/HI_geoid2.nc', d_path);
	gmt([cmd ' -R160/20/220/30r -JOc190/25.5/292/69/4.5i -E50 -K -P -B10 -X1.5i -Y1.25i > '  ps], g_cpt)
	gmt(['psscale -DjRM+o0.6i/0+jLM+w2.88i/0.4i+mc+e -R -J -O -K -Bx2+lGEOID -By+lm >> ' ps], g_cpt)
	t_cpt = gmt(sprintf('grd2cpt %s/HI_topo2.nc -Crelief -Z', d_path));
	GHI_topo2_int = gmt(sprintf('grdgradient %s/HI_topo2.nc -A0 -Nt', d_path));
	cmd = sprintf('grdimage %s/HI_topo2.nc', d_path);
	gmt([cmd ' -I -R -J -B+t"H@#awaiian@# T@#opo and @#G@#eoid@#"' ...
        ' -B10 -E50 -O -K -C -Y4.5i --MAP_TITLE_OFFSET=0.5i >> ' ps], GHI_topo2_int, t_cpt)
	gmt(['psscale -DjRM+o0.6i/0+jLM+w2.88i/0.4i+mc -R -J -O -K -I0.3 -Bx2+lTOPO -By+lkm >> ' ps], t_cpt)
% gmt pstext -R0/8.5/0/11 -Jx1i -F+f30p,Helvetica-Bold+jCB -O -N -Y-4.5i >> $ps << END
% -0.4 7.5 a)
% -0.4 3.0 b)
% END
	builtin('delete','gmt.conf');

% -------------------------------------------------------------------------------------------------
function ex04()
	global g_root_dir out_path
	d_path = [g_root_dir 'doc/examples/ex04'];
	ps = [out_path 'example_04.ps'];

	fid = fopen('zero.cpt','w');
	fprintf(fid, '%s\n', '-10  255   0  255');
	fprintf(fid, '%s\n', '  0  100  10  100');
	fclose(fid);

	cmd = sprintf('grdcontour %s/HI_geoid4.nc', d_path);
	gmt([cmd ' -R195/210/18/25 -Jm0.45i -p60/30 -C1 -A5+o -Gd4i -K -P -X1.25i -Y1.25i > ' ps])
	gmt(['pscoast -R -J -p -B2 -BNEsw -Gblack -O -K -TdjBR+o0.1i+w1i+l >> ' ps])
	gmt([sprintf('grdview %s/HI_topo4.nc', d_path) ' -R195/210/18/25/-6/4 -J -Jz0.34i -p -Czero.cpt -O -K ' ...
		' -N-6+glightgray -Qsm -B2 -Bz2+l"Topo (km)" -BneswZ -Y2.2i >> ' ps])
	gmt(['pstext -R0/10/0/10 -Jx1i -F+f60p,ZapfChancery-MediumItalic+jCB -O >> ' ps], {'3.25 5.75 H@#awaiian@# R@#idge@#'})
	builtin('delete','zero.cpt');

	ps = [out_path 'example_04c.ps'];
	Gg_intens = gmt([sprintf('grdgradient %s/HI_geoid4.nc', d_path) ' -A0 -Nt0.75 -fg']);
	Gt_intens = gmt([sprintf('grdgradient %s/HI_topo4.nc', d_path)  ' -A0 -Nt0.75 -fg']);
	gmt([sprintf('grdimage %s/HI_geoid4.nc', d_path) ...
		' -I -R195/210/18/25 -JM6.75i -p60/30 -C' d_path '/geoid.cpt -E100 -K -P -X1.25i -Y1.25i > ' ps], Gg_intens)
	gmt(['pscoast -R -J -p -B2 -BNEsw -Gblack -O -K >> ' ps])
	gmt(['psbasemap -R -J -p -O -K -TdjBR+o0.1i+w1i+l --COLOR_BACKGROUND=red --FONT=red' ...
		' --MAP_TICK_PEN_PRIMARY=thinner,red >> ' ps])
	gmt(['psscale -R -J -p240/30 -DJBC+o0/0.5i+w5i/0.3i+h -C' d_path '/geoid.cpt -I -O -K -Bx2+l"Geoid (m)" >> ' ps])
	gmt([sprintf('grdview %s/HI_topo4.nc', d_path) ' -I -R195/210/18/25/-6/4 -J -C' d_path '/topo.cpt' ...
		' -JZ3.4i -p60/30 -O -K -N-6+glightgray -Qc100 -B2 -Bz2+l"Topo (km)" -BneswZ -Y2.2i >> ' ps], Gt_intens)
	gmt(['pstext -R0/10/0/10 -Jx1i -F+f60p,ZapfChancery-MediumItalic+jCB -O >> ' ps], {'3.25 5.75 H@#awaiian@# R@#idge@#'})

% -------------------------------------------------------------------------------------------------
function ex06()
	global g_root_dir out_path
	d_path = [g_root_dir 'doc/examples/ex06'];
	ps = [out_path 'example_06.ps'];

	gmt(['psrose ' d_path '/fractures.d -: -A10r -S1.8in -P -Gorange -R0/1/0/360 -X2.5i -K -Bx0.2g0.2' ...
		' -By30g30 -B+glightblue -W1p > ' ps])
	gmt(['pshistogram -Bxa2000f1000+l"Topography (m)" -Bya10f5+l"Frequency"+u" %"' ...
		' -BWSne+t"Histograms"+glightblue ' d_path '/v3206.t -R-6000/0/0/30 -JX4.8i/2.4i -Gorange -O' ...
		' -Y5.0i -X-0.5i -L1p -Z1 -W250 >> ' ps])

% -------------------------------------------------------------------------------------------------
function ex07()
	global g_root_dir out_path
	d_path = [g_root_dir 'doc/examples/ex07'];
	ps = [out_path 'example_07.ps'];

	gmt(['pscoast -R-50/0/-10/20 -JM9i -K -Slightblue -GP300/26:FtanBdarkbrown -Dl -Wthinnest' ...
		' -B10 --FORMAT_GEO_MAP=dddF > ' ps])
	gmt(['psxy -R -J -O -K ' d_path '/fz.xy -Wthinner,- >> ' ps])
	gmt(['psxy ' d_path '/quakes.xym -R -J -O -K -h1 -Sci -i0,1,2s0.01 -Gred -Wthinnest >> ' ps])
	gmt(['psxy -R -J -O -K ' d_path '/isochron.xy -Wthin,blue >> ' ps])
	gmt(['psxy -R -J -O -K ' d_path '/ridge.xy -Wthicker,orange >> ' ps])
	gmt(['psxy -R -J -O -K -Gwhite -Wthick -A >> ' ps], [-14.5 15.2; -2 15.2; -2 17.8; -14.5 17.8])
	gmt(['psxy -R -J -O -K -Gwhite -Wthinner -A >> ' ps], [-14.35 15.35; -2.15 15.35; -2.15 17.65; -14.35 17.65])
	gmt(['psxy -R -J -O -K -Sc0.08i -Gred -Wthinner >> ' ps], [-13.5 16.5])
	gmt(['pstext -R -J -F+f18p,Times-Italic+jLM -O -K >> ' ps], {'-12.5 16.5 ISC Earthquakes'})
	gmt(['pstext -R -J -O -F+f30,Helvetica-Bold,white=thin >> ' ps], {'-43 -5 SOUTH' '-43 -8 AMERICA' '-7 11 AFRICA'})

% -------------------------------------------------------------------------------------------------
function ex08()
	global g_root_dir out_path
	d_path = [g_root_dir 'doc/examples/ex08'];
	ps = [out_path 'example_08.ps'];

	xyz = gmt(['grd2xyz ' d_path '/guinea_bay.nc']);
	gmt(['psxyz -B1 -Bz1000+l"Topography (m)" -BWSneZ+b+tETOPO5' ...
		' -R-0.1/5.1/-0.1/5.1/-5000/0 -JM5i -JZ6i -p200/30 -So0.0833333ub-5000 -P' ...
		' -Wthinnest -Glightgreen -K > ' ps], xyz)
	gmt(['pstext -R -J -JZ -Z0 -F+f24p,Helvetica-Bold+jTL -p -O >> ' ps], {'0.1 4.9 This is the surface of cube'})

% -------------------------------------------------------------------------------------------------
function ex09()
	global g_root_dir out_path
	d_path = [g_root_dir 'doc/examples/ex09'];
	ps = [out_path 'example_09.ps'];

	gmt(['pswiggle ' d_path '/tracks.txt -R185/250/-68/-42 -K -Jm0.13i -Ba10f5 -BWSne+g240/255/240 -G+red' ...
		' -G-blue -Z2000 -Wthinnest -S240/-67/500/@~m@~rad --FORMAT_GEO_MAP=dddF > ' ps])
	gmt(['psxy -R -J -O -K ' d_path '/ridge.xy -Wthicker >> ' ps])
	gmt(['psxy -R -J -O -K ' d_path '/fz.xy    -Wthinner,- >> ' ps])
	% Take label from segment header and plot near coordinates of last record of each track
	% BUT THIS CURRENTLY FAILS BECAUSE CODE FLOW GOES TRHOUGH gmt_api #2492 AND 
	% GMT_IS_REFERENCE_VIA_VECTOR DOESN'T KNOW HOW TO DEAL WITH THE gmtconvert -El OPTION
	%t = gmt(['gmtconvert -El ' d_path '/tracks.txt']);
	%gmt(['pstext -R -J -F+f10p,Helvetica-Bold+a50+jRM+h -D-0.05i/-0.05i -O >> ' ps], t)

% -------------------------------------------------------------------------------------------------
function ex10()
	global g_root_dir out_path
	d_path = [g_root_dir 'doc/examples/ex10'];
	ps = [out_path 'example_10.ps'];

	gmt(['pscoast -Rd -JX8id/5id -Dc -Sazure2 -Gwheat -Wfaint -A5000 -p200/40 -K > ' ps])
	fid = fopen([d_path '/languages.txt']);
	str = fread(fid,'*char');
	fclose(fid);
	str = strread(str','%s','delimiter','\n');
	k = 1;
	while (str{k}(1) == '#')
		k = k + 1;
	end
	str = str(k:end);		% Remove the comment lines
	nl = numel(str);
	array = zeros(nl, 7);
	for (k = 1:nl)
		array(k,:) = strread(str{k}, '%f', 7);
	end
	t = cell(nl,1);
	for (k = 1:nl)
		t{k} = sprintf('%d %d %d\n',array(k,1:2),sum(array(k,3:end)));
	end
	gmt(['pstext -R -J -O -K -p -Gwhite@30 -D-0.25i/0 -F+f30p,Helvetica-Bold,firebrick=thinner+jRM >> ' ps], t)
	gmt(['psxyz ' d_path '/languages.txt -R-180/180/-90/90/0/2500 -J -JZ2.5i -So0.3i -Gpurple -Wthinner' ...
		' --FONT_TITLE=30p,Times-Bold --MAP_TITLE_OFFSET=-0.7i -O -K -p --FORMAT_GEO_MAP=dddF' ...
		' -Bx60 -By30 -Bza500+lLanguages -BWSneZ+t"World Languages By Continent" >> ' ps])
	gmt(['psxyz -R -J -JZ -So0.3ib -Gblue -Wthinner -O -K -p >> ' ps], [array(:,1:2) sum(array(:,3:4),2) array(:,3)])
	gmt(['psxyz -R -J -JZ -So0.3ib -Gdarkgreen -Wthinner -O -K -p >> ' ps], [array(:,1:2) sum(array(:,3:5),2) sum(array(:,3:4),2)])
	gmt(['psxyz -R -J -JZ -So0.3ib -Gyellow -Wthinner -O -K -p >> ' ps], [array(:,1:2) sum(array(:,3:6),2) sum(array(:,3:5),2)])
	gmt(['psxyz -R -J -JZ -So0.3ib -Gred -Wthinner -O -K -p >> ' ps], [array(:,1:2) sum(array(:,3:7),2) sum(array(:,3:6),2)])
	% BUG HERE. NOTHING IS WRITTEN BY THE NEXT COMMAND 
	gmt(['pslegend -R -J -JZ -DjLB+o0.2i+w1.35i/0+jBL -O --FONT=Helvetica-Bold' ...
		' -F+glightgrey+pthinner+s-4p/-6p/grey20@40 -p ' d_path '/legend.txt -Vl >> ' ps])

% -------------------------------------------------------------------------------------------------
function ex23()
	global out_path
	ps = [out_path 'example_23.ps'];

	% Position and name of central point:
	lon  = 12.50;	lat  = 41.99;
	name = 'Rome';

	Gdist = gmt(sprintf('grdmath -Rg -I1 %f %f SDIST', lon, lat));

	gmt(['pscoast -Rg -JH90/9i -Glightgreen -Sblue -A1000 -Dc -Bg30 -B+t"Distances from ' ...
		name ' to the World" -K -Wthinnest > ' ps])

	gmt(['grdcontour -A1000+v+u" km"+fwhite -Glz-/z+ -S8 -C500 -O -K -JH90/9i -Wathin,white ' ...
		' -Wcthinnest,white,- >> ' ps], Gdist)
	
	% Location info for 5 other cities + label justification
	cities = cell(5,1);
	cities{1} = '105.87 21.02 LM HANOI';
	cities{2} = '282.95 -12.1 LM LIMA';
	cities{3} = '178.42 -18.13 LM SUVA';
	cities{4} = '237.67 47.58 RM SEATTLE';
	cities{5} = '28.20 -25.75 LM PRETORIA';
	fid = fopen('cities.d','w');
	for (k = 1:5)
		fprintf(fid, '%s\n', cities{k});
	end
	fclose(fid);

	% For each of the cities, plot great circle arc to Rome with gmt psxy
	gmt(['psxy -R -J -O -K -Wthickest,red >> ' ps], [lon lat; 105.87 21.02])
	gmt(['psxy -R -J -O -K -Wthickest,red >> ' ps], [lon lat; 282.95 -12.1])
	gmt(['psxy -R -J -O -K -Wthickest,red >> ' ps], [lon lat; 178.42 -18.13])
	gmt(['psxy -R -J -O -K -Wthickest,red >> ' ps], [lon lat; 237.67 47.58])
	gmt(['psxy -R -J -O -K -Wthickest,red >> ' ps], [lon lat; 28.20 -25.75])

	% Plot red squares at cities and plot names:
	for (k = 1:5)
		gmt(['pstext -R -J -O -K -Dj0.15/0 -F+f12p,Courier-Bold,red+j -N >> ' ps], cities(k))	% It should accept a plain string as well
	end

	% Place a yellow star at Rome
	gmt(['psxy -R -J -O -K -Sa0.2i -Gyellow -Wthin >> ' ps], [12.5 41.99])

	% Sample the distance grid at the cities and use the distance in km for labels
	dist = gmt('grdtrack cities.d -G', Gdist);
	t = cell(5,1);
	for (k = 1:5)
		t{k} = sprintf('%f %f %d', dist(k,1), dist(k,2), round(dist(k,end)));
	end
	gmt(['pstext -R -J -O -D0/-0.2i -N -Gwhite -W -C0.02i -F+f12p,Helvetica-Bold+jCT >> ' ps], t)
	builtin('delete','cities.d');

% -------------------------------------------------------------------------------------------------
function ex44()
	global out_path
	ps = [out_path 'example_44.ps'];

	% Bottom map of Australia
	gmt(['pscoast -R110E/170E/44S/9S -JM6i -P -Baf -BWSne -Wfaint -N2/1p  -EAU+gbisque -Gbrown' ...
		' -Sazure1 -Da -K -Xc --FORMAT_GEO_MAP=dddF > ' ps])
	gmt(['psbasemap -R -J -O -K -DjTR+w1.5i+o0.15i/0.1i+sxx000 -F+gwhite+p1p+c0.1c+s >> ' ps])
	t = load('xx000');		% x0 y0 w h
	cmd = sprintf('pscoast -Rg -JG120/30S/%f -Da -Gbrown -A5000 -Bg -Wfaint -EAU+gbisque -O -K -X%f -Y%f >> %s', t(3), t(1), t(2), ps);
	gmt(cmd)
	gmt(sprintf('psxy -R -J -O -K -T -X-%f -Y-%f >> %s', t(1), t(2), ps),0)
	% Determine size of insert map of Europe
	t = gmt('mapproject -R15W/35E/30N/48N -JM2i -W',0);	% w h
	gmt(['pscoast -R10W/5E/35N/44N -JM6i -Baf -BWSne -EES+gbisque -Gbrown -Wfaint -N1/1p -Sazure1' ...
		' -Df -O -K -Y4.5i --FORMAT_GEO_MAP=dddF >> ' ps])
	gmt(sprintf('psbasemap -R -J -O -K -DjTR+w%f/%f+o0.15i/0.1i+sxx000 -F+gwhite+p1p+c0.1c+s >> %s', t(1), t(2), ps))
	t = load('xx000');		% x0 y0 w h
	cmd = sprintf('pscoast -R15W/35E/30N/48N -JM%f -Da -Gbrown -B0 -EES+gbisque -O -K -X%f -Y%f ', t(3), t(1), t(2));
	gmt([cmd '--MAP_FRAME_TYPE=plain >> ' ps])
	gmt(sprintf('psxy -R -J -O -T -X-%f -Y-%f >> %s', t(1), t(2), ps),0)
	builtin('delete','xx000');