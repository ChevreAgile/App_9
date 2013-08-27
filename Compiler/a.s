    .globl _App_9_func
_App_9_func:
	    pushq %rbx
	    pushq %rbp
	    pushq %r12
	    pushq %r13
	    pushq %r14
	    pushq %r15
	    movq %rdi, %rbp
	    movq %rsi, %rdx
	    leaq _App_9_func_exit(%rip), %r15
	    movq %r15, %rcx
	    movq $48, %rax
	    jmp *%rcx
_App_9_func_exit:
	    popq %r15
	    popq %r14
	    popq %r13
	    popq %r12
	    popq %rbp
	    popq %rbx
	    ret       