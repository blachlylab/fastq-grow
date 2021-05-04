module fqg;

import std.conv;
import std.stdio;
import std.string;

const string VERSION = "1.1";

int main(string[] argv)
{
	int BCLEN = 6;
    int rowidx;
	string readid;
	bool grow;
    ulong growcount;

    if (argv.length > 2) {
        stderr.writefln("usage: %s [barcode_len: int (default: 6)]", argv[0]);
        return 1;
    }
    else if (argv.length == 2)
        BCLEN = argv[1].to!int;    // default 6
    

	stderr.writefln("[fastq_grow %s started, BCLEN=%d]", VERSION, BCLEN);

	auto range = stdin.byLine();
	foreach(line; range) {
		switch (rowidx & 3) {
			case 0:	{ writeln(line); readid = line.dup(); break; }
			case 1:	{
				if(line.length < BCLEN) {
					grow = true;
                    growcount++;
					writeln( leftJustify( line, BCLEN, 'N' ) );
					stderr.writefln( "%s\t%s -> %s", leftJustify(readid, 70), line, leftJustify( line, BCLEN, 'N' ) );
				}
				else if (line.length > BCLEN) assert(0, "Line longer than barcode length");
				else writeln( line );
				break;
			}
			case 2: writeln("+"); break;
			case 3: {
				if (grow) { writeln( leftJustify( line, BCLEN, '#' ) ); grow = false; }
				else writeln(line);
				break;
			}
			default: assert(0);
		}
		rowidx++;
	}

    stderr.writefln("[fastq_grow finished, n rows grown=%d]", growcount);
	return 0;
}
