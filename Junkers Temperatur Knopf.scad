$fn=600;

// Einstellknopf für Solltemperaturen Junkers Heizungsregler TA-213

// Abmessungen in mm
koerper_d = 15;
koerper_h = 4.75;

kragen_d = 17;
kragen_h = 1.20;

welle_d = 4;
welle_h = 3.5;

anfasser_h = 3.5;

anschlag_d_aussen = 21;
anschlag_d_innen = 13;
anschlag_h = 1.0;

steckachse_d = 3.8;
steckachse_h = 5.65;
steckachse_slot_h = steckachse_h;
steckachse_slot_b = 0.75;
steckachse_d_abgeflacht = 2.8;


// Erster Versuch mit OpenSCAD

module anfasser_abrunder() {
    union() {
        translate([0, koerper_d/2, 0])
            rotate([90, 0, 0])
                cylinder(h=koerper_d, r=1);
        translate([0, -koerper_d/2, -1])
            cube([20, koerper_d, 2]);
        translate([-1, -koerper_d/2, 0])
            cube([21, koerper_d, anfasser_h + 0.1]);
    }
}

module knopf_koerper() {
    cylinder(h = koerper_h + anfasser_h, d = koerper_d);
    translate([0, 0, -kragen_h])
        cylinder(h = kragen_h, d = kragen_d);

    translate([0, 0, -kragen_h - welle_h])
        cylinder(h = welle_h, d = welle_d);
}

module knopf_mit_anfasser() {
    difference() {
        knopf_koerper();
        for (i = [0, 180]) {
            rotate([0, 0, i])
                translate([2.25, 0, 4.75])
                  anfasser_abrunder();
        }
        translate([0, 5.85, 4.75+3.5])
            cube([1, 3.4, 2], center=true);
    }
}

module steckachse() {
    abschnitt = steckachse_d - steckachse_d_abgeflacht;
    
    difference() {
        cylinder(h=steckachse_h, d=steckachse_d, center=true);
        translate([0, 0, -0.25])
            cube([steckachse_slot_b, steckachse_d, steckachse_slot_h], center=true);
        
        for (i=[1, -1]) {
            translate([0, i * (steckachse_d_abgeflacht/2 + abschnitt/4), 0])
                cube([steckachse_d, abschnitt/2, steckachse_h + 0.1], center=true);
        }
    }
}

module anschlag() {    
    difference() {
        cylinder(h=anschlag_h, d=anschlag_d_aussen, center=true);
        cylinder(h=anschlag_h + 0.1, d=anschlag_d_innen, center=true);
        
        for (i = [0, 135]) {
            rotate([0, 0, i])
                translate([0, 5.25, 0])
                    cube([anschlag_d_aussen, anschlag_d_aussen/2, anschlag_h + 0.1], center=true);
        }
    }
}

union() {
    knopf_mit_anfasser();
    translate([0, 0, -(kragen_h + welle_h)-(steckachse_h/2)])
        steckachse();
    translate([0, 0, -(kragen_h + anschlag_h/2)])
        anschlag();
}