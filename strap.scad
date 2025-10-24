// TPU Fit Adjustment Strap for Shokz Bone Conduction Headphones
// Designed for flexible 3D printing
$fn = $preview ? 32 : 128;

// Cuff parameters
cuff_inner_diameter = 3;    // Inner diameter in mm
cuff_outer_diameter = 10;  // Outer diameter in mm
cuff_gap = 0.4;             // Gap for mounting in mm
cuff_height = 8;            // Height of cuff in mm


// Strap parameters
strap_thickness = 3;        // Thickness in mm
strap_width = 20;           // Width in mm
strap_length = 200;         // Length in mm
cable_width = 4;            // Width of the thin cable section in mm
taper_length = 20;          // Length of the taper from strap to cable in mm
cable_section_length = 5;  // Length of the straight cable section at each end


// Create the complete strap module
module headphone_strap() {
    union() {
        // Left cuff
        translate([-strap_length/2, 0, cuff_outer_diameter/2 - strap_thickness/2])
            rotate([90, 0, 0])
            cuff_with_gap();

    // Main strap body
    strap_body();
    
    // Right cuff
    translate([strap_length/2, 0, cuff_outer_diameter/2 - strap_thickness/2])
        rotate([90, 0, 0])
        cuff_with_gap();
}

}


// Module for cuff with mounting gap
module cuff_with_gap() {
    difference() {
        // Full cuff
        cylinder(h=cuff_height, d=cuff_outer_diameter, center=true);


    // Inner hole
    cylinder(h=cuff_height + 1, d=cuff_inner_diameter, center=true);
    
    // Gap for mounting
    translate([0, cuff_outer_diameter/2 + cuff_gap/4, 0])
        cube([cuff_outer_diameter + 1, cuff_gap, cuff_height + 1], center=true);
}

}


// Main strap body (flat for printing)
module strap_body() {
    // Central tapered section
    tapered_part_length = strap_length - 2 * cable_section_length;
    hull() { 
        // Central wide part
        cube([tapered_part_length - 2 * taper_length, strap_width, strap_thickness], center=true);

        // Left narrow end of taper
        translate([-tapered_part_length / 2, 0, 0])
            cube([0.1, cable_width, strap_thickness], center=true);

        // Right narrow end of taper
        translate([tapered_part_length / 2, 0, 0])
            cube([0.1, cable_width, strap_thickness], center=true);
    }

    // Left cable section
    translate([-strap_length/2 + cable_section_length/2, 0, 0])
        cube([cable_section_length, cable_width, strap_thickness], center=true);

    // Right cable section
    translate([strap_length/2 - cable_section_length/2, 0, 0])
        cube([cable_section_length, cable_width, strap_thickness], center=true);
}

// Render the complete model
headphone_strap();