use <cuff_prototype.scad>

// TPU Fit Adjustment Strap for Shokz Bone Conduction Headphones
// Designed for flexible 3D printing
$fn = $preview ? 32 : 128;

// Cuff parameters
cuff_inner_diameter = 3.5;    // Inner diameter in mm
cuff_outer_diameter = 9;  // Outer diameter in mm
cuff_gap = 0.4;             // Gap for mounting in mm
cuff_height = 8;            // Height of cuff in mm
fastener_length = 30;      // Length of the integrated strap fastener in mm
fastener_strap_width = 3;   // Width of the flexible strap
fastener_strap_thickness = 1; // Thickness of the flexible strap
bar_diameter = 3;           // Diameter of the T-bar
bar_length = 10;            // Length of the T-bar

// Strap parameters
strap_thickness = 3;        // Thickness in mm
strap_width = 20;           // Width in mm
strap_length = 150;         // Length in mm
cable_width = 7;            // Width of the thin cable section in mm
taper_length = 20;          // Length of the taper from strap to cable in mm
cable_section_length = 0;  // Length of the straight cable section at each end

// Ridge parameters
ridge_height = 0;         // Height of the ridge from the strap surface
ridge_width = 8;            // Width of the ridge at its base
ridge_length = 190;         // Length of the ridge (set to strap_length for cuff-to-cuff)
ridge_offset = 0;           // Transverse offset from the strap's centerline

// Create the complete strap module
module headphone_strap() {
    union() {
        // Left cuff
        translate([-strap_length/2, 0, cuff_outer_diameter/2 - strap_thickness/2])
            rotate([0, 0, 0])
                cuff_with_strap_fastener(fastener_strap_length=fastener_length);

        // Main strap with slots and ridge
        difference() {
            union() {
                strap_body();
                ridge();
            }
            // Position for the slots, 2mm into the taper
            slot_x_pos = (strap_length/2) - cable_section_length - taper_length + 2;
            // Right slot
            translate([slot_x_pos, 0, 0]) fastener_slot();
            // Left slot
            translate([-slot_x_pos, 0, 0]) fastener_slot();
        }

        // Right cuff
        translate([strap_length/2, 0, cuff_outer_diameter/2 - strap_thickness/2])
            rotate([0, 0, 180])
                cuff_with_strap_fastener(fastener_strap_length=fastener_length);
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

// Module for the T-bar fastener slot
module fastener_slot() {
    translate([0, 0, strap_thickness/2])
        cube([bar_length * 1.1, bar_diameter * 1.1, strap_thickness + 1], center=true);
}

// Module for the reinforcing ridge
module ridge() {
    // Calculate the length of the strap's non-tapered central section
    strap_center_len = strap_length - 2 * cable_section_length - 2 * taper_length;

    // Position the ridge on the strap's main surface
    translate([0, ridge_offset, strap_thickness/2]) {
        // Use hull to create a tapered ridge if it's long enough
        if (ridge_length > strap_center_len) {
            hull() {
                // Central wide part of the ridge
                ridge_segment(strap_center_len, ridge_width, ridge_height, center=true);
                // Narrow ends of the ridge
                translate([-ridge_length/2, 0, 0]) 
                    ridge_segment(0.1, cable_width, ridge_height, center=true);
                translate([ridge_length/2, 0, 0]) 
                    ridge_segment(0.1, cable_width, ridge_height, center=true);
            }
        } else {
            // If the ridge is short, just create a non-tapered version
            ridge_segment(ridge_length, ridge_width, ridge_height);
        }
    }
}

// Helper module for a semi-elliptical ridge segment
module ridge_segment(l, w, h, center=false) {
    intersection() {
        scale([1, 1, h / w]) rotate([0, 90, 0]) cylinder(h=l, d=w, center=center);
        translate([center ? 0 : l/2, 0, h/2]) cube([l+1, w+1, h], center=true);
    }
}

// Render the complete model
headphone_strap();