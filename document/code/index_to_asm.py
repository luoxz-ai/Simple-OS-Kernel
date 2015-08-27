# -*- coding: cp936 -*-

def sal_or_add_print(count,var,aux):
    if count == 1:
        print 'add %s, %s' % (var,var)
    else:
        print 'sal %s, %d' % (var,count)
    return

def mul_to_add(const,var='EAX',aux='EDX'):
    """
    将变量与常数的乘法转换为加法与移位
    的组合。假设变量已经被载入var和aux
    """
    const_bin = str(bin(const))[2:]
    op_list = []
    for bit in const_bin[1:]:
        if bit == '0':
            op_list.append('sal')
        else:
            op_list.append('sal')
            op_list.append('add')
            
    count = 0
    for op in op_list:
        if op == 'sal':
            count += 1
        elif op == 'add':
            sal_or_add_print(count,var,aux)
            print 'add %s, %s' % (var,aux)
            count = 0

    sal_or_add_print(count,var,aux)
    return

def convert_poly(index_list,dimension_list):
    

mul_to_add(336)
