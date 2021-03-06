#include <config.h>
#include <linux/linkage.h>

#include <asm/armv7.h>
#include <asm/arch-armv7/generictimer.h>
#include <asm/psci.h>

	.pushsection ._secure.text, "ax"

	.arch_extension sec

	@ r1 = target CPU
	@ r2 = target PC

.globl	psci_arch_init
psci_arch_init:
	mov	r6, lr

	bl	psci_get_cpu_id
	bl	psci_get_cpu_stack_top
	mov	sp, r0

	bx	r6

	@ r1 = target CPU
	@ r2 = target PC

.globl psci_cpu_on
psci_cpu_on:
	push	{lr}

	bl	psci_cpu_on_common

	ldr	r2, =psci_cpu_entry
	bl	imx_cpu_on

	pop	{pc}

.globl psci_cpu_off
psci_cpu_off:

	bl	psci_cpu_off_common
	bl	psci_get_cpu_id
	bl	imx_cpu_off

1: 	wfi
	b 1b

	.globl psci_text_end
psci_text_end:
	.popsection
