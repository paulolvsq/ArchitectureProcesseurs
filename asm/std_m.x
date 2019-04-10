
;  ### -------------------------------------------------------------- ###
;  # file	: std_m.x						#
;  # date	: Sep  2 2009						#
;  # descr.	: functional test for Mips R3000			#
;  ### -------------------------------------------------------------- ###

	;  ### ------------------------------------------------------ ###
	;  #   exception section					#
	;  #     - no reorder						#
	;  ### ------------------------------------------------------ ###

			.excep
			.set	noreorder

	;  ### ------------------------------------------------------ ###
	;  #   constants						#
	;  ### ------------------------------------------------------ ###

exccode_mask		.equ	0x003c

unexpected_exc_code	.equ	0x04
simulation_exit_code	.equ	0x10

	;  ### ------------------------------------------------------ ###
	;  #   peripherals address					#
	;  ### ------------------------------------------------------ ###

terminal_adr		.equ	kernel_term_begin
sim_controller		.equ	user_cntl_begin

	;  ### ------------------------------------------------------ ###
	;  #   exception and interrupt handler				#
	;  ### ------------------------------------------------------ ###

_excpetion_handler :

	;  ### ------------------------------------------------------ ###
	;  #   jump to the sub-routines that handle each particular	#
	;  # exception cause						#
	;  ### ------------------------------------------------------ ###

			la	r26,      exc_causes_table

			mfc0	r27,      cause
			andi	r27, r27, exccode_mask

			addu	r26, r26, r27
			lw	r27, 0 (r26)

			jr	r27
			nop

	;  ### ------------------------------------------------------ ###
	;  #   table of exception causes sub-routine address		#
	;  ### ------------------------------------------------------ ###

			.align	2
exc_causes_table :
			.word	_other_causes		;  0 : interrupts
			.word	_other_causes		;  1 : reserved
			.word	_other_causes		;  2 : reserved
			.word	_other_causes		;  3 : reserved
			.word	_other_causes		;  4 : load  adr error
			.word	_other_causes		;  5 : store adr error
			.word	_other_causes		;  6 : inst bus error
			.word	_other_causes		;  7 : data bus error
			.word	_syscall_cause		;  8 : syscall
			.word	_other_causes		;  9 : break
			.word	_other_causes		; 10 : illegal inst
			.word	_other_causes		; 11 : copro unusable
			.word	_other_causes		; 12 : overflow
			.word	_other_causes		; 13 : trap
			.word	_other_causes		; 14 : reserved
			.word	_other_causes		; 15 : reserved

	;  ### ------------------------------------------------------ ###
	;  #   table of syscall sub-routines address			#
	;  ### ------------------------------------------------------ ###

			.align	2
syscall_table :
			.word	_syscall_exit
			.word	_syscall_putchar
			.word	_syscall_puts
			.word	_syscall_fputs
			.word	_syscall_GetCacheStats

	;  ### ------------------------------------------------------ ###
	;  #   jump to the appropriate syscall sub-routine		#
	;  ### ------------------------------------------------------ ###

_syscall_cause :
			la	r26, syscall_table
	
			addu	r26, r26, r2		; syscall number
			lw   	r27, 0 (r26)
			jr	r27
			nop

_syscall_return :
			mfc0	r27, epc
			addiu	r27, r27, 4
			mtc0	r27, epc

			eret

	;  ### ------------------------------------------------------ ###
	;  #   syscall : exit						#
	;  ### ------------------------------------------------------ ###

_syscall_exit :
			ori	r26, r0 , simulation_exit_code
			la	r27,      sim_controller
			sb	r26, 0 (r27)

			j	_endless_loop
			nop

	;  ### ------------------------------------------------------ ###
	;  #   syscall : puts						#
	;  ### ------------------------------------------------------ ###

_syscall_puts :
			lb	r9 , 0 (r4 )
			la	r8 , terminal_adr
			beq	r9 , r0 , _puts_end_loop
			nop
_puts_loop :
			sb	r9 , 0 (r8 )
			lb	r9 , 1 (r4 )
			addiu	r4 , r4 , 1

			bne	r9 , r0 , _puts_loop
			nop

_puts_end_loop :
			ori	r9 , r0 , '\n'		; print '\n'
			sb	r9 , 0 (r8 )

			ori	r2 , r0 , 1
			j	_syscall_return

	;  ### ------------------------------------------------------ ###
	;  #   syscall : fputs						#
	;  ### ------------------------------------------------------ ###

_syscall_fputs :
			la	r8 , terminal_adr

			lb	r9 , 0 (r4 )
			beq	r9 , r0 , _fputs_end_loop
			nop
_fputs_loop :
			sb	r9 , 0 (r8 )
			lb	r9 , 1 (r4 )
			addiu	r4 , r4 , 1

			bne	r9 , r0 , _fputs_loop
			nop

_fputs_end_loop :
			ori	r2 , r0 , 1
			j	_syscall_return

	;  ### ------------------------------------------------------ ###
	;  #   syscall : putchar					#
	;  ### ------------------------------------------------------ ###

_syscall_putchar :
			la	r8 , terminal_adr
			sb	r4 , 0 (r8 )

			add	r2 , r4 , r0
			j	_syscall_return

	;  ### ------------------------------------------------------ ###
	;  #   syscall : GetCacheStats					#
	;  #								#
	;  #   coprocessor 2's performance counters :			#
	;  #								#
	;  #   - $33 : data transaction cycle				#
	;  #   - $34 : stall cycle due to data access			#
	;  #   - $35 : data read request				#
	;  #   - $36 : miss - uncachable data        read  request	#
	;  #   - $37 : miss - cachable   data        read  request	#
	;  #           clean cache block replacement			#
	;  #   - $38 : miss - cachable   data        read  request	# 
	;  #           dirty cache block replacement			#
	;  #   - $39 : stall cycle due to read data access		#
	;  #   - $40 : data write request				#
	;  #   - $41 : miss - uncachable data        write request	#
	;  #   - $42 : miss - cachable   data        write request	#
	;  #           clean cache block replacement			#
	;  #   - $43 : miss - cachable   data        write request	#
	;  #           dirty cache block replacement			#
	;  #   - $44 : stall cycle due to write data access		#
	;  #   - $45 : memory update transaction			#
	;  #								#
	;  #   - $49 : instruction transaction cycle			#
	;  #   - $50 : stall cycle due to instruction read		#
	;  #   - $52 : instruction read request				#
	;  #   - $53 : miss - uncachable instruction read  request	#
	;  #   - $54 : miss - cachable   instruction read  request	#
	;  #           clean cache block replacement			#
	;  ### ------------------------------------------------------ ###

_syscall_GetCacheStats :
			lw	r9 ,      0*4 (r4 )
			mfc0    r8 , count
			subu	r8 , r8 , r9
			sw	r8 ,      0*4 (r4 )

			lw	r9 ,      1*4 (r4 )
			mfc2    r8 , $33
			subu	r8 , r8 , r9
			sw	r8 ,      1*4 (r4 )

			lw	r9 ,      2*4 (r4 )
			mfc2    r8 , $34
			subu	r8 , r8 , r9
			sw	r8 ,      2*4 (r4 )

			lw	r9 ,      3*4 (r4 )
			mfc2    r8 , $35
			subu	r8 , r8 , r9
			sw	r8 ,      3*4 (r4 )

			lw	r9 ,      4*4 (r4 )
			mfc2    r8 , $36
			subu	r8 , r8 , r9
			sw	r8 ,      4*4 (r4 )

			lw	r9 ,      5*4 (r4 )
			mfc2    r8 , $37
			subu	r8 , r8 , r9
			sw	r8 ,      5*4 (r4 )

			lw	r9 ,      6*4 (r4 )
			mfc2    r8 , $38
			subu	r8 , r8 , r9
			sw	r8 ,      6*4 (r4 )

			lw	r9 ,      7*4 (r4 )
			mfc2    r8 , $39
			subu	r8 , r8 , r9
			sw	r8 ,      7*4 (r4 )

			lw	r9 ,      8*4 (r4 )
			mfc2    r8 , $40
			subu	r8 , r8 , r9
			sw	r8 ,      8*4 (r4 )

			lw	r9 ,      9*4 (r4 )
			mfc2    r8 , $41
			subu	r8 , r8 , r9
			sw	r8 ,      9*4 (r4 )

			lw	r9 ,     10*4 (r4 )
			mfc2    r8 , $42
			subu	r8 , r8 , r9
			sw	r8 ,     10*4 (r4 )

			lw	r9 ,     11*4 (r4 )
			mfc2    r8 , $43
			subu	r8 , r8 , r9
			sw	r8 ,     11*4 (r4 )

			lw	r9 ,     12*4 (r4 )
			mfc2    r8 , $44
			subu	r8 , r8 , r9
			sw	r8 ,     12*4 (r4 )

			lw	r9 ,     13*4 (r4 )
			mfc2    r8 , $45
			subu	r8 , r8 , r9
			sw	r8 ,     13*4 (r4 )

			lw	r9 ,     14*4 (r4 )
			mfc2    r8 , $49
			subu	r8 , r8 , r9
			sw	r8 ,     14*4 (r4 )

			lw	r9 ,     15*4 (r4 )
			mfc2    r8 , $50
			subu	r8 , r8 , r9
			sw	r8 ,     15*4 (r4 )

			lw	r9 ,     16*4 (r4 )
			mfc2    r8 , $52
			subu	r8 , r8 , r9
			sw	r8 ,     16*4 (r4 )

			lw	r9 ,     17*4 (r4 )
			mfc2    r8 , $53
			subu	r8 , r8 , r9
			sw	r8 ,     17*4 (r4 )

			lw	r9 ,     18*4 (r4 )
			mfc2    r8 , $54
			subu	r8 , r8 , r9
			sw	r8 ,     18*4 (r4 )

			move	r2 , r4
			j	_syscall_return

	;  ### ------------------------------------------------------ ###
	;  #   other causes						#
	;  ### ------------------------------------------------------ ###

_other_causes :
			ori	r27, r0 , unexpected_exc_code
			la	r26,      sim_controller

			sb	r27, 0 (r26)
			j	_endless_loop
			nop

	;  ### ------------------------------------------------------ ###
	;  #   endless loop						#
	;  ### ------------------------------------------------------ ###

_endless_loop :
			j	_endless_loop
			nop

			.end
