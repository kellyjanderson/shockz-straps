

// Cuff Prototype for Shokz Fit Adjustment Strap
$fn = $preview ? 32 : 128;

// --- Parameters --- //

// --- Modules --- //

module cuff_with_strap_fastener(
    // Cuff Body
    cuff_inner_diameter = 3.5,
    cuff_outer_diameter = 9,
    cuff_height = 8,
    cuff_gap = 1,
    // Integrated Strap
    fastener_strap_length = 25,
    fastener_strap_width = 3,
    fastener_strap_thickness = 1,
    // Fastening Bar
    bar_diameter = 3,
    bar_length = 10
) {
    union() {
        // The main C-shaped cuff body, centered at the origin
        rotate([90, 0, 0]) 
            cuff_body(cuff_height, cuff_outer_diameter, cuff_inner_diameter, cuff_gap);

        // The main length of the flexible strap, extending from the cuff's edge
        translate([-(fastener_strap_length/2), 0,  -(cuff_outer_diameter/2 - fastener_strap_thickness/2)])
            cube([fastener_strap_length, fastener_strap_width, fastener_strap_thickness], center=true);

        // The T-bar at the end of the strap
        translate([-fastener_strap_length, 0, -(cuff_outer_diameter/2 - bar_diameter/2)])
            rotate([90, 0, 0])
                cylinder(h=bar_length, d=bar_diameter, center=true);
    }
}

module cuff_body(height, outer_d, inner_d, gap) {
    difference() {
        cylinder(h=height, d=outer_d, center=true);
        cylinder(h=height + 1, d=inner_d, center=true);
        translate([outer_d/2, 0, 0])
            cube([outer_d, gap, height+1], center=true);
    }
}

// Render the cuff for prototyping
cuff_with_strap_fastener();