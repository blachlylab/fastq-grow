module fqg;

import std.stdio;
import std.string;

const int BCLEN = 6;

int main()
{
	int rowidx;
	string readid;
	bool grow;

	stderr.writeln("[fastq_grow started]");

	auto range = stdin.byLine();
	foreach(line; range) {
		switch (rowidx & 3) {
			case 0:	{ writeln(line); readid = line.dup(); break; }
			case 1:	{
				if(line.length < BCLEN) {
					grow = true;
					writeln( leftJustify( line, 6, 'N' ) );
					stderr.writefln( "%s\t%s -> %s", leftJustify(readid, 70), line, leftJustify( line, 6, 'N' ) );
				}
				else if (line.length > BCLEN) assert(0);
				else writeln( line );
				break;
			}
			case 2: writeln("+"); break;
			case 3: {
				if (grow) { writeln( leftJustify( line, 6, '#' ) ); grow = false; }
				else writeln(line);
				break;
			}
			default: assert(0);
		}
		rowidx++;
	}

	return 0;
}
