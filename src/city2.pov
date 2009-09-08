#include "colors.inc"
#include "textures.inc"
#include "woods.inc"
#include "math.inc"

#declare seed1 = seed(0);

camera {
	sky <0,0,-1>
	#switch(clock)
	#range(-1,0)
		look_at <0,0,0>
		location <0,-100,-300>
	#break
	#range(0,1)
		look_at <
			50 * sind(clock*360),
			50 * sind(clock*360),
			0
		>
		location <
			 100 * sind(720 * clock),
			-100 * cosd(720 * clock),
			-300 + 200 * sind(360 * clock)
		>
	#break
	#range(1,2)
		look_at <0,0,0> // confirmed
	        location <0,-100,-300 + 100 * sind(360 * clock)>
	#break
	#range(2,4)
		look_at <0,0,0> // confirmed
		location <-50 * sind(180*clock),-100 + 50 * sind(180*clock),-300 + 200 * sind(180*clock)>
	#end
}

#switch (clock)
#range (-1,0)
	light_source  { <-150,-150,-10 - 50*(1+sind(clock))>
		color rgb <1, 0.5 - clock * 0.5, 0.5 - clock * 0.5> }
	light_source  { <-200, 200,-10 - 50*(1+sind(clock))>
		color rgb <0.5 - clock * 0.5, 1, 0.5 - clock * 0.5> }
	light_source  { < 200,-200,-10 - 50*(1+sind(clock))>
		color rgb <0.5 - clock * 0.5, 0.5 - clock * 0.5, 1> }
#break
#range (0,1)
	light_source  { <-150,-150,-10 - 50*(1+sind(clock))> color rgb <1  ,0.5,0.5> }
	light_source  { <-200, 200,-10 - 50*(1+sind(clock))> color rgb <0.5,1  ,0.5> }
	light_source  { < 200,-200,-10 - 50*(1+sind(clock))> color rgb <0.5,0.5,1  > }
#break
#range (1,3)
	light_source  {
		<-150,-150,-60>
		color rgb <1,0.5,0.5>
		rotate <0,0,-clock*720>
	}
	light_source  {
		<-200,200,-60>
		color rgb <0.5,1,0.5>
		rotate <0,0,-clock*720>
	}
	light_source  {
		<200,-200,-60>
		color rgb <0.5,0.5,1>
		rotate <0,0,-clock*720>
	}
#break
#range (3,4)
	light_source  {
		<-150,-150,-60>
		color rgb <1,0.5 + 0.5 * (clock - 3),0.5 + 0.5 * (clock - 3)>
		rotate <0,0,-clock*720>
	}
	light_source  {
		<-200,200,-60>
		color rgb <0.5 + 0.5 * (clock - 3),1,0.5 + 0.5 * (clock - 3)>
		rotate <0,0,-clock*720>
	}
	light_source  {
		<200,-200,-60>
		color rgb <0.5 + 0.5 * (clock - 3),0.5 + 0.5 * (clock - 3),1>
		rotate <0,0,-clock*720>
	}
#break
#end

fog { 
	fog_type 1
	color rgb <0.8,0.2,0.2>
	distance 2000
	turbulence 0.1
	fog_offset 0.1
	fog_alt 0.2
}

background { color Black }

#macro building(bheigth,intexture,inx,iny)
	#local decide = rand(seed1);
	#if (inx < 0)
		#local bwidth  = 12 * rand(seed1);
		#local blength = 12 * rand(seed1);
	#else
		#local bwidth = inx;
                #local blength = iny;
	#end
	union {
		box {
			<0, 0, 0>
			<bwidth, blength, bheight>
		}
		box {
			#if (decide > 0.7)
				#local lbl = sqrt(f_sqr(blength)/2);
				<0, 0, 0>
				<bwidth, lbl, lbl>
				rotate <-45,0,0>
			#else
				#if (decide < 0.3)
					#local lbl = sqrt(f_sqr(bwidth)/2);
					<0, 0, 0>
					<lbl,blength,lbl>
					rotate <0,45,0>
				#else
					<0, 0, 0>
					<bwidth,blength/2,-5>
				#end
			#end
			translate <0,0,bheight>
		}
		texture {
			intexture
			scale decide + 0.5
		}
	}
#end

#macro auto_building(bheight)
	#local decide = rand(seed1);
	#local tex = texture {
		mysf4
	}
	building(bheight,tex,-1,-1)
#end

#declare mysf4 = pigment {
	brick
	Gray30,
	White
	brick_size 10
	mortar 8
	scale <0.2,0.2,1>
}

#macro city(inradius,inheight,inbounds)
// bounds are needed so that pseudorands are maintained as city grows
union {
	#if (inbounds < 0)
		#declare inbounds = inradius;
	#end
	#declare gridy = -inbounds;
	#while (gridy <= inbounds)
        	#declare gridx = -inbounds;
        	#while  (gridx <= inbounds)
			#declare rad = sqrt(f_sqr(gridx) + f_sqr(gridy));
	                #declare bheight = (inheight/inradius) * (rad - inradius) * rand(seed1);
			#if (rad < inradius) // correct
               			object {
               			        auto_building(bheight)
               			        translate <gridx,gridy,0>
               			}
			#else
				#declare nullthing = auto_building(bheight);
			#end
                	#declare gridx = gridx + 10;
        	#end
        	#declare gridy = gridy + 10;
	#end
}
#end
plane {
	<0,0,-1> (-1 * 10)
	texture {
                pigment {
			checker Black Gray30
			scale 50
                }
        }
	rotate <0,0,45>
}
cylinder {
	<0,0,0>
	<0,0,10>
	#switch(clock)
	#range(-1,0)
		120 + clock * 70 // (init,final) 50,120
	#break
	#range(0,2)
		120 // 120
	#break
	#range(2,3)
		100 * clock - 80 // (init,final) 120,220
	#break
	#range(3,4)
		220 - 170 * (clock - 3) // (init,final) 220,50
	#break
	#end
	texture {
                pigment {
			checker Black White
			scale 50
                }
        }
}
#switch(clock)
#range (-1,0)
	#local crad = 100 + 70 * clock; // (init,final) 30,100
	city(crad,0,200)
#break
#range (0,2)
	#local cheight = 100 * clock;
	city(100,cheight,200)
#break
#range (2,3)
	#local cheight =  600 - 200 * clock; // (init,final) 200,0
	#local crad    = -100 + 100 * clock; // (init,final) 100,200
	city(crad,cheight,200)
#break
#range (3,4)
	#local crad = 200 - 170 * (clock - 3); // (init,final) 200,30
	city(crad,0,200)
#break
#end
