$fs = 0.1;
$fa = 0.25;
stem_outer_size = 5.8;
stem_slit_size = 1.3;
stem_slit_length = 4.2;

module stem() {
    difference() {
    
      cylinder(d = stem_outer_size, h = 4.8);
        
      // cross
      translate([- stem_slit_size / 2, - stem_slit_length / 2])
      cube([stem_slit_size, stem_slit_length, 4.8]);
      translate([- stem_slit_length / 2, - stem_slit_size / 2])
        cube([stem_slit_length, stem_slit_size, 4.8]);
    }
}

module rounded_cube(size, r) {
    h = 0.0001;
    
    minkowski() {
        cube([size[0] - r * 2, size[1] - r * 2, size[2] - h], center = true);
        cylinder(r = r, h = h);
      
    }
}

// get round of dish
function dish_r(w, d) = (w * w + 4 * d * d) / (8 * d);

module keycap_outer_shape (key_bottom_size, key_top_size, key_top_height, angle, dish_depth) {
    translate([0, 0, 3.3])
    difference() {
        hull() {
            translate([0, 0, key_top_height ])
              rotate([- angle, 0, 0])
                rounded_cube([key_top_size, key_top_size, 0.01], 3);
            rounded_cube([key_bottom_size, key_bottom_size, 0.01], 3);
        }
        translate([0, 0, key_top_height])
          rotate([- angle, 0, 0])
            translate([0, 0, dish_r(key_top_size * sqrt(2), dish_depth) - dish_depth])
              rotate([90, 0, 0])
                sphere(dish_r(key_top_size * sqrt(2), dish_depth));
    }
}

module keycap_inner_shape (key_bottom_size, key_top_size, key_top_height) {
    translate([0, 0, 3.3])
    hull() {
        translate([0, 0, key_top_height ])
            rounded_cube([key_top_size, key_top_size, 0.01], 3);
        rounded_cube([key_bottom_size, key_bottom_size, 0.01], 3);
    }
}

module keycap_convex_shape (key_bottom_size, key_top_size, key_top_height, dish_depth) {
    translate([0, 0, 3.3 + key_top_height])
    minkowski() {
        difference() {
            translate([-((key_top_size - 3 * 2) / 2), 0,  -(dish_r(key_top_size - 3 * 2, dish_depth) - dish_depth)])
              rotate([0, 90, 0])
                cylinder(h = key_top_size - 6, r = dish_r(key_top_size - 6, dish_depth));
            
          translate([-50, -50, -100])
           cube([100, 100, 100]);
        }
        cylinder(r = 3, h = 0.0001);
    }
    translate([0, 0, 3.3])
    hull() {
        translate([0, 0, key_top_height ])
            rounded_cube([key_top_size, key_top_size, 0.01], 3);
        rounded_cube([key_bottom_size, key_bottom_size, 0.01], 3);
    }
}

       

module keycap_shape_bottom() {
    difference() {
        keycap_outer_shape(16, 16, 4, -7, 1);
        keycap_inner_shape(15, 15, 1.5);
    }
}

module keycap_shape_center() {
    difference() {
        keycap_outer_shape(16, 16, 4, 0, 1);
        keycap_inner_shape(15, 15, 1.5);
    }
}

module keycap_shape_top() {
    difference() {
        keycap_outer_shape(16, 16, 4, 7, 1);
        keycap_inner_shape(15, 15, 1.5);
    }
}

module keycap_shape_sumkey() {
    difference() {
        keycap_convex_shape(16, 16, 4, 2);;
        keycap_inner_shape(15, 15, 1.5);
    }
}

module keycap_top() {
    keycap_shape_top();
    stem();
}

module keycap_center() {
    keycap_shape_center();
    stem();
}

module keycap_bottom() {
    keycap_shape_bottom();
    stem();
}

module keycap_sumkey() {
    keycap_shape_sumkey();
    stem();
}

for (x = [0, 1, 2, 3, 4, 5])
    translate([19 * x, 0 , 0])
      keycap_top();


for (x = [0, 1, 2, 3, 4, 5])
    translate([19 * x, 19 , 0])
      keycap_center();
    
for (x = [0, 1, 2, 3, 4, 5])
    translate([19 * x, 19 * 2 , 0])
      keycap_bottom();

for (x = [0, 1, 2])
    translate([19 * x, 19 * 3 , 0])
      keycap_sumkey();
