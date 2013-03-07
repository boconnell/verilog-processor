/* Assembler code fragment for RiSC-16 assembler */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAXLINELENGTH 1000

typedef struct labelAndLine_ {
	char label[100];
	int line;
} labelAndLine;

char * readAndParseLine(FILE *inFilePtr, char *lineString,
	char **labelPtr, char **opcodePtr, char **arg);
int isRegister(char *string);
int getSignedImm(char *string, labelAndLine *labelTable);
int getUnsignedImm(char *string, labelAndLine *labelTable);
int getLabelValue(char *label, labelAndLine *labelTable);
int rriType(char **arg, labelAndLine *labelTable);
int jalr(char **arg, labelAndLine *labelTable);
int rrrType(char **arg);
int riType(char **arg, labelAndLine *labelTable);
int bne(char **arg, labelAndLine *labelTable);
int fill(char **arg, labelAndLine *labelTable);
void report(char *message);

int pc = -1;
int compiled = 1;

int main(int argc, char *argv[])
{
	char *inFileString, *outFileString;
	FILE *inFilePtr, *outFilePtr;
	char *label, *opcode, *arg[3];
	char lineString[MAXLINELENGTH+1];
	labelAndLine labelTable[128];

	if (argc != 3) {
		printf("error: usage: %s <assembly-code-file> <machine-code-file>\n", argv[0]);
		exit(1);
	}

	inFileString = argv[1];
	outFileString = argv[2];

	inFilePtr = fopen(inFileString, "r");
	if (inFilePtr == NULL) {
		printf("error in opening %s\n", inFileString);
		exit(1);
	}
	outFilePtr = fopen(outFileString, "w");
	if (outFilePtr == NULL) {
		printf("error in opening %s\n", outFileString);
		exit(1);
	}

	/* Start first pass */
	int numLabels = 0;
	int line = 0;
	while (readAndParseLine(inFilePtr, lineString, &label, &opcode, arg)){
		if (label){
			int i;
			for (i = 0; i < numLabels; ++i){
				if (strcmp(labelTable[i].label, label) == 0){
					printf("Line %d: Duplicate label (%s) found. Using line number of first encounter.\n", line, label);
					break;
				}
			}
			if (i == numLabels){
				strcpy(labelTable[numLabels].label, label);
				labelTable[numLabels].line = line;
				numLabels++;
			}
		}
		line++;
	}

	/* End first pass */

	rewind(inFilePtr);

	/* Start second pass */
	int hexcode;
	pc = 0;
	while (readAndParseLine(inFilePtr, lineString, &label, &opcode, arg)){
		hexcode = 0;
		if (strcmp(opcode, "add") == 0){
			hexcode |= rrrType(arg);
		}else if (strcmp(opcode, "addi") == 0){
			hexcode |= (1 << 13);
			hexcode |= rriType(arg, labelTable);
		}else if (strcmp(opcode, "nand") == 0){
			hexcode |= (2 << 13);
			hexcode |= rrrType(arg);
		}else if (strcmp(opcode, "lui") == 0){
			hexcode |= (3 << 13);
			hexcode |= riType(arg, labelTable);
		}else if (strcmp(opcode, "sw") == 0){
			hexcode |= (4 << 13);
			hexcode |= rriType(arg, labelTable);
		}else if (strcmp(opcode, "lw") == 0){
			hexcode |= (5 << 13);
			hexcode |= rriType(arg, labelTable);
		}else if (strcmp(opcode, "bne") == 0){
			hexcode |= (6 << 13);
			hexcode |= bne(arg, labelTable);
		}else if (strcmp(opcode, "jalr") == 0){
			hexcode |= (7 << 13);
			hexcode |= jalr(arg, labelTable);
			hexcode &= 0xFF80;
		}else if (strcmp(opcode, "nop") == 0){
			if (arg[0] || arg[1] || arg[2]){
				report("Too many arguments");
			}
			hexcode = 0x0000;
		}else if (strcmp(opcode, "halt") == 0){
			if (arg[0] || arg[1] || arg[2]){
				report("Too many arguments");
			}
			hexcode = 0xE071;
		}else if (strcmp(opcode, ".fill") == 0){
			hexcode |= fill(arg, labelTable);
		}else{
			report("Unrecognized opcode");
		}
		fprintf(outFilePtr, "%0.4hx\n", hexcode);
		++pc;
	}

	if (compiled == 0){
		printf("ERROR: Program assembled unsuccessfully\n");
	}else{
		printf("Program assembled successfully!\n");
	}
	/* End second pass */
}

void report(char *message){
	compiled = 0;
	printf("Line %d: %s\n", pc, message);
}

int fill(char **arg, labelAndLine *labelTable){
	int val;
	if (arg[1] || arg[2]){
		report("Too many arguments");
	}
	if (sscanf(arg[0], "%d", &val) == 1){
		return val;
	}else{
		if ((val = getLabelValue(arg[0], labelTable)) == -1){
			report("Label could not be found");
		}
		return val;
	}
}

int bne(char **arg, labelAndLine *labelTable){
	int val, hexcode = 0, labelValue;
	if ((val = isRegister(arg[0])) != -1){
		hexcode |= (val << 10);
		if ((val = isRegister(arg[1])) != -1){
			hexcode |= (val << 7);
		}
		if ((sscanf(arg[2], "%d", &val)) == 1){
			if (val < -64 || val > 63){
				report("Unisgned Immediate out of range (-6 -> 63)");
			}
		}else{
			if ((val = getLabelValue(arg[2], labelTable)) == -1){
				report("Label could not be found");
			}
			val = val - pc - 1;
			if (val < -64 || val > 63){
				report("Warning: bne offset will not fit within signed immediate bit space");
			}
		}
		if (val < 0){
			val &= 0x003F;
			hexcode |= 0x0040;
		}
		hexcode |= val & 0x007F;
	}
	return hexcode;
}

int jalr(char **arg, labelAndLine *labelTable){
	int hexcode = 0, labelValue;
	int val;
	if ((val = isRegister(arg[0])) != -1){
		hexcode |= (val << 10);
		if ((val = isRegister(arg[1])) != -1){
			hexcode |= (val << 7);
		}
	}
	return hexcode;
}

int rriType(char **arg, labelAndLine *labelTable){
	int hexcode = 0, labelValue;
	int val;
	if ((val = isRegister(arg[0])) != -1){
		hexcode |= (val << 10);
		if ((val = isRegister(arg[1])) != -1){
			hexcode |= (val << 7);
		}
		val = getSignedImm(arg[2], labelTable);
		if (val < 0){
			val = val & 0x003F;
			hexcode |= 0x0040;
		}
		hexcode |= val;
	}
	return hexcode;
}

int rrrType(char **arg){
	int hexcode = 0, val;
	if ((val = isRegister(arg[0])) != -1){
		hexcode |= (val << 10);
		if ((val = isRegister(arg[1])) != -1){
			hexcode |= (val << 7);
			if ((val = isRegister(arg[2])) != -1){
				hexcode |= val;
			}
		}
	}
	return hexcode;
}

int riType(char **arg, labelAndLine *labelTable){
	int hexcode = 0, labelValue, val;
	if (arg[2]){
		report("Too many arguments");
	}
	if ((val = isRegister(arg[0])) != -1){
		hexcode |= (val << 10);
	}
	if ((val = getUnsignedImm(arg[1], labelTable)) != -1){
		hexcode |= val;
	}
	return hexcode;
}

int getLabelValue(char *label, labelAndLine *labelTable){
	int i;
	for (i = 0; i < 128; ++i){
		if (labelTable[i].label == NULL){
			return -1;
		}
		if (strcmp(label, labelTable[i].label) == 0){
			return labelTable[i].line;
		}
	}
	return -1;
}

char * readAndParseLine(FILE *inFilePtr, char *lineString,
	char **labelPtr, char **opcodePtr, char **arg)
{
	/* read and parse a line
	note that lineString must point to allocated memory,
	so that *labelPtr, *opcodePtr, and *argXPtr
	won't be pointing to readAndParse's memory
	also note that *labelPtr, *opcodePtr, and *argXPtr
	only point to memory in lineString.
	When lineString changes, so will *labelPtr,
	*opcodePtr, and *argXPtr
	returns NULL if at end-of-file */

	char *statusString, *firsttoken;
	*labelPtr = *opcodePtr = arg[0] = arg[1] = arg[2] = NULL;
	statusString = fgets(lineString, MAXLINELENGTH, inFilePtr);
	if (statusString != NULL) {
		firsttoken = strtok(lineString, " \t\n");
		if (firsttoken == NULL || firsttoken[0] == '#') {
			return readAndParseLine(inFilePtr, lineString, labelPtr, opcodePtr, arg);
		} else if (firsttoken[strlen(firsttoken) - 1] == ':') {
			*labelPtr = firsttoken;
			*opcodePtr = strtok(NULL, " \t\n");
			firsttoken[strlen(firsttoken) - 1] = '\0';
		} else {
			*labelPtr = NULL;
			*opcodePtr = firsttoken;
		}
		arg[0] = strtok(NULL, ", \t\n");
		if (arg[0] && arg[0][0] != '#'){
			arg[1] = strtok(NULL, ", \t\n");
			if (arg[1] && arg[1][0] != '#'){
				arg[2] = strtok(NULL, ", \t\n");
				if (arg[2] && arg[2][0] != '#'){
					char *toomanyargs = strtok(NULL, ", \t\n");
					if ((toomanyargs && toomanyargs[0] != '#')  && pc != -1){
						report("Too many arguments");
					}
				}else{
					arg[2] = NULL;
				}
			}else{
				arg[1]= NULL;
			}
		}else{
			arg[0] = NULL;
		}
	}
	return(statusString);
}

int isRegister(char *string){
	if (string == NULL){
		report("Missing arguments");
		return -1;
	}
	int i;
	if ((sscanf(string, "%d", &i)) == 1){
		if (i < 0 || i > 7){
			report("Register out of range");
			return -1;
		}
		return i & 0x7;
	}else{
		report("Invalid argument");
		return -1;
	}
}

int getSignedImm(char *string, labelAndLine *labelTable){
	int i;
	if ((sscanf(string, "%d", &i)) == 1){
		if (i < -64 || i > 63){
			report("Signed Immediate out of range (-64 -> 63)");
		}
		return i;
	}else{
		int labelValue;
		if ((labelValue = getLabelValue(string, labelTable)) == -1){
			report("Label could not be found");
		}
		return labelValue;
	}
}

int getUnsignedImm(char *string, labelAndLine *labelTable){
	int i;
	if ((sscanf(string, "%d", &i)) == 1){
		if (i < 0 || i > 1023){
			report("Unisgned Immediate out of range (0 -> 1023)");
			return -1;
		}else{
			return i;
		}
	}else{
		int labelValue;
		if ((labelValue = getLabelValue(string, labelTable)) == -1){
			report("Label could not be found");
			return -1;
		}
		return labelValue;
	}
}