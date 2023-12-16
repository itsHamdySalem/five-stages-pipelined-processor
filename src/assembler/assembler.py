no_operand_instructions = {
    "NOP":      0b00000,
    "RET":      0b11100,
    "RTI":      0b11101,
}

one_operand_instructions = {
    "NOT":      0b00001,
    "NEG":      0b00010,
    "INC":      0b00011,
    "DEC":      0b00100,
    "PUSH":     0b00101,
    "POP":      0b00110,
    "PROTECT":  0b00111,
    "FREE":     0b01000,
    "JZ":       0b01001,
    "JMP":      0b01010,
    "CALL":     0b01011,
    "IN":       0b01100,
    "OUT":      0b01101,
}

two_operand_instructions = {
    "ADD":      0b01110,
    "SUB":      0b01111,
    "SWAP":     0b10000,
    "CMP":      0b10001,
    "AND":      0b10010,
    "OR":       0b10011,
    "XOR":      0b10100,
}

immediate_value_instructions = {
    "ADDI":     0b10101,
    "BITSET":   0b10110,
    "RCL":      0b10111,
    "RCR":      0b11000,
    "LDM":      0b11001,
}

effective_address_instructions = {
    "LDD":      0b11010,
    "STD":      0b11011,
}

opcodes = {
    **no_operand_instructions,
    **one_operand_instructions,
    **two_operand_instructions,
    **immediate_value_instructions,
    **effective_address_instructions,
}

general_purpose_registers = {
    "R0": 0b000,
    "R1": 0b001,
    "R2": 0b010,
    "R3": 0b011,
    "R4": 0b100,
    "R5": 0b101,
    "R6": 0b110,
    "R7": 0b111,
}

registers = {
    **general_purpose_registers,
}

OPCODE_SHIFT = 11
RD_SHIFT = 8
RS1_SHIFT = 5
RS2_SHIFT = 2


def assemble_no_operand_instruction(opcode):
    opcode_value = no_operand_instructions[opcode]

    machine_code = (opcode_value << OPCODE_SHIFT)
    return [machine_code]


def assemble_one_operand_instruction(opcode, Rd):
    Rd_value = registers.get(Rd, None)

    if Rd_value is None:
        raise ValueError(f"Unknown register: {Rd} for opcode: {opcode}")

    opcode_value = one_operand_instructions[opcode]

    machine_code = (opcode_value << OPCODE_SHIFT) | (Rd_value << RD_SHIFT)
    return [machine_code]


def assemble_two_operand_instruction(opcode, Rd, Rs1, Rs2):
    Rd_value = registers.get(Rd, None)
    Rs1_value = registers.get(Rs1, None)
    Rs2_value = registers.get(Rs2, None)

    if Rd_value is None:
        raise ValueError(f"Unknown register: {Rd} for opcode: {opcode}")
    elif Rs1_value is None:
        raise ValueError(f"Unknown register: {Rs1} for opcode: {opcode}")
    elif Rs2_value is None:
        raise ValueError(f"Unknown register: {Rs2} for opcode: {opcode}")

    opcode_value = two_operand_instructions[opcode]

    machine_code = (opcode_value << OPCODE_SHIFT) | (Rd_value << RD_SHIFT) | (
        Rs1_value << RS1_SHIFT) | (Rs2_value << RS2_SHIFT)
    return [machine_code]


def assemble_immediate_value_instruction(opcode, Rd, immediate):
    Rd_value = registers.get(Rd, None)

    if Rd_value is None:
        raise ValueError(f"Unknown register: {Rd} for opcode: {opcode}")

    opcode_value = immediate_value_instructions[opcode]

    machine_code1 = (opcode_value << OPCODE_SHIFT) | (Rd_value << RD_SHIFT)
    machine_code2 = immediate
    return [machine_code1, machine_code2]


def assemble_effective_address_instruction(opcode, Rd, EA):
    Rd_value = registers.get(Rd, None)

    if Rd_value is None:
        raise ValueError(f"Unknown register: {Rd} for opcode: {opcode}")

    opcode_value = effective_address_instructions[opcode]

    machine_code1 = (opcode_value << OPCODE_SHIFT) | (
        Rd_value << RD_SHIFT) | (EA >> 16)
    machine_code2 = (EA << 4)
    return [machine_code1, machine_code2]


input_file_path = "ISA.txt"
output_file_path = "program.mem"

with open(input_file_path, "r") as input_file, open(output_file_path, "w") as output_file:
    for line in input_file:
        line = line.strip().upper()

        if not line:
            continue

        segments = line.split()

        if not segments:
            continue

        # print(segments)

        opcode = segments[0]
        machine_codes = None

        if opcode in no_operand_instructions:
            machine_codes = assemble_no_operand_instruction(opcode)
        elif opcode in one_operand_instructions:
            machine_codes = assemble_one_operand_instruction(
                opcode, segments[1])
        elif opcode in two_operand_instructions:
            machine_codes = assemble_two_operand_instruction(
                opcode, segments[1], segments[2], segments[3])
        elif opcode in immediate_value_instructions:
            machine_codes = assemble_immediate_value_instruction(
                opcode, segments[1], int(segments[2]))
        elif opcode in effective_address_instructions:
            machine_codes = assemble_effective_address_instruction(
                opcode, segments[1], int(segments[2]))
        else:
            raise ValueError(f"Unknown opcode: {opcode}")

        for machine_code in machine_codes:
            print(f"{machine_code:016b}")
            output_file.write(f"{machine_code:016b}\n")

print(f"Conversion completed. Machine code written to {output_file_path}.")
