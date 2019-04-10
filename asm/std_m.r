
;  ###----------------------------------------------------------------###
;  # file	: std_m.r						#
;  # date	: Sep  2 2009						#
;  # descr.	: functional test for Mips R3000			#
;  ###----------------------------------------------------------------###

	;  ###--------------------------------------------------------###
	;  #   reset section						#
	;  #     - no reorder						#
	;  ###--------------------------------------------------------###

			.reset
			.set	noreorder

	;  ###--------------------------------------------------------###
	;  #   initialization prgram (hardware RESET)			#
	;  ###--------------------------------------------------------###

user_status		.equ	0x0000ff15

reset_sw_int		.equ	0x00000000
user_stack		.equ	user_stack_begin
user_prog		.equ	_main

	;  ###--------------------------------------------------------###
	;  #   initialization prgram (hardware RESET)			#
	;  ###--------------------------------------------------------###

_hardware_reset:
			mtc0	r0 , count

			la	r29, user_stack		; user stack pointer

			li	r27, excp_text_base
			mtc0	r27, ebase

			li	r27, user_status
			mtc0	r27, status

			la	r27, user_prog
			mtc0	r27, eepc

			li	r27, reset_sw_int
			mtc0	r27, cause

			eret				; return from reset

	;  ###--------------------------------------------------------###
	;  #   exception						#
	;  ###--------------------------------------------------------###

			.bexcep

unexpected_btx_code	.equ    0x08
sim_controller		.equ	user_cntl_begin

	;  ###--------------------------------------------------------###
	;  #   signaling bad execution					#
	;  ###--------------------------------------------------------###

_ex_it_handler :
_unexpected_ex :
			addiu	r26, r0 , unexpected_btx_code
			la	r27,      sim_controller
			j	_end_loop
			nop

_end_loop :
			sb	r26, 0 (r27)
			j	_end_loop
			nop

			.end
