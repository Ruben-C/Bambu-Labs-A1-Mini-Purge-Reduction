;===== machine: A1 mini =========================
;===== date: 20231012 =======================
G392 S0
M620 S[next_extruder]A
M204 S9000
{if toolchange_count > 1}
G17
G2 Z{max_layer_z + 0.4} I0.86 J0.86 P1 F10000 ; spiral lift a little from second lift
{endif}
G1 Z{max_layer_z + 3.0} F1200

M400
M106 P1 S0
M106 P2 S0
{if old_filament_temp > 142 && next_extruder < 255}
M104 S[old_filament_temp]
{endif}

;60% Purge Reduction Code
G1 E-20 F200 ;Retract extruder 20mm at 200mm/min
M400         ;Wait until retract is complete
;End of Code

G1 X180 F18000
;{if toolchange_count == 2}
; get travel path for change filament
;M620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0
;M620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1
;M620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2
;{endif}
M620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}
T[next_extruder]
M620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}

G1 Y90 F9000

{if next_extruder < 255}
M400

;60% Purge Reduction Code
G1 E18 F200 ;Extract 18mm at 200mm/min
G1 E2 F20   ;Extract 2mm at 20mm/min
M400        ;Wait until extraction is complete
;End of Code

G92 E0
{if flush_length_1 > 1}
; FLUSH_START
; always use highest temperature to flush
M400
M1002 set_filament_type:UNKNOWN
M109 S[nozzle_temperature_range_high]
M106 P1 S60
{if flush_length_1 > 23.7}
G1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
{else}
G1 E{flush_length_1} F{old_filament_e_feedrate}
{endif}
; FLUSH_END
G1 E-[old_retract_length_toolchange] F1800
G1 E[old_retract_length_toolchange] F300
M400
M1002 set_filament_type:{filament_type[next_extruder]}
{endif}

{if flush_length_1 > 45 && flush_length_2 > 1}
; WIPE
M400
M106 P1 S178
M400 S3
G1 X-3.5 F18000
G1 X-13.5 F3000
G1 X-3.5 F18000
G1 X-13.5 F3000
G1 X-3.5 F18000
G1 X-13.5 F3000
M400
M106 P1 S0
{endif}

{if flush_length_2 > 1}
M106 P1 S60
; FLUSH_START
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
; FLUSH_END
G1 E-[new_retract_length_toolchange] F1800
G1 E[new_retract_length_toolchange] F300
{endif}

{if flush_length_2 > 45 && flush_length_3 > 1}
; WIPE
M400
M106 P1 S178
M400 S3
G1 X-3.5 F18000
G1 X-13.5 F3000
G1 X-3.5 F18000
G1 X-13.5 F3000
G1 X-3.5 F18000
G1 X-13.5 F3000
M400
M106 P1 S0
{endif}

{if flush_length_3 > 1}
M106 P1 S60
; FLUSH_START
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
; FLUSH_END
G1 E-[new_retract_length_toolchange] F1800
G1 E[new_retract_length_toolchange] F300
{endif}

{if flush_length_3 > 45 && flush_length_4 > 1}
; WIPE
M400
M106 P1 S178
M400 S3
G1 X-3.5 F18000
G1 X-13.5 F3000
G1 X-3.5 F18000
G1 X-13.5 F3000
G1 X-3.5 F18000
G1 X-13.5 F3000
M400
M106 P1 S0
{endif}

{if flush_length_4 > 1}
M106 P1 S60
; FLUSH_START
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
; FLUSH_END
{endif}

M400
M106 P1 S60
M109 S[new_filament_temp]
G1 E5 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature
M400
G92 E0
G1 E-[new_retract_length_toolchange] F1800
M400
M106 P1 S178
M400 S3
G1 X-3.5 F18000
G1 X-13.5 F3000
G1 X-3.5 F18000
G1 X-13.5 F3000
G1 X-3.5 F18000
G1 X-13.5 F3000
G1 X-3.5 F18000
M400
G1 Z{max_layer_z + 3.0} F3000
M106 P1 S0
{if layer_z <= (initial_layer_print_height + 0.001)}
M204 S[initial_layer_acceleration]
{else}
M204 S[default_acceleration]
{endif}
{else}
G1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000
{endif}
M621 S[next_extruder]A
G392 S1
