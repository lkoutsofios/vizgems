/***********************************************************************
*                                                                      *
*               This software is part of the ast package               *
*          Copyright (c) 1989-2011 AT&T Intellectual Property          *
*                      and is licensed under the                       *
*                 Eclipse Public License, Version 1.0                  *
*                    by AT&T Intellectual Property                     *
*                                                                      *
*                A copy of the License is available at                 *
*          http://www.eclipse.org/org/documents/epl-v10.html           *
*         (with md5 checksum b35adb5213ca9657e911e9befb180842)         *
*                                                                      *
*              Information and Software Systems Research               *
*                            AT&T Research                             *
*                           Florham Park NJ                            *
*                                                                      *
*                 Glenn Fowler <gsf@research.att.com>                  *
*                                                                      *
***********************************************************************/
#pragma prototyped
/*
 * David Korn
 * AT&T Research
 *
 * banner [-d delim] [-w width] arg ...
 */

static const char usage[] =
"[-?\n@(#)$Id: banner (AT&T Research) 1999-04-28 $\n]"
USAGE_LICENSE
"[+NAME?banner - print large banner]"
"[+DESCRIPTION?\bbanner\b prints a large banner on the standard output.]"

"[d:delimiter?The banner print character is \achar\a.]:[char:=#]"
"[w:width?The banner print width is \awidth\a.]#[width:=80]"

"\n"
"\n[ message ... ]\n"
"\n"
"[+SEE ALSO?\blpr\b(1), \bpr\b(1)]"
;

#include	<cmd.h>
#include	<ccode.h>

#define CHAR_HEIGHT	8

const unsigned char bandata[128][CHAR_HEIGHT] =
{
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
	 0x38, 0x38, 0x38, 0x10, 0, 0x38, 0x38, 0,
	 0xee, 0xee, 0x44, 0, 0, 0, 0, 0,
	 0x28, 0x28, 0xfe, 0x28, 0xfe, 0x28, 0x28, 0,
	 0x7c, 0x92, 0x90, 0x7c, 0x12, 0x92, 0x7c, 0,
	 0xe2, 0xa4, 0xe8, 0x10, 0x2e, 0x4a, 0x8e, 0,
	 0x30, 0x48, 0x30, 0x70, 0x8a, 0x84, 0x72, 0,
	 0x38, 0x38, 0x10, 0x20, 0, 0, 0, 0,
	 0x18, 0x20, 0x40, 0x40, 0x40, 0x20, 0x18, 0,
	 0x30, 0x8, 0x4, 0x4, 0x4, 0x8, 0x30, 0,
	 0, 0x44, 0x28, 0xfe, 0x28, 0x44, 0, 0,
	 0, 0x10, 0x10, 0x7c, 0x10, 0x10, 0, 0,
	 0, 0, 0, 0x38, 0x38, 0x10, 0x20, 0,
	 0, 0, 0, 0x7c, 0, 0, 0, 0,
	 0, 0, 0, 0, 0x38, 0x38, 0x38, 0,
	 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80, 0,
	 0x38, 0x44, 0x82, 0x82, 0x82, 0x44, 0x38, 0,
	 0x10, 0x30, 0x50, 0x10, 0x10, 0x10, 0x7c, 0,
	 0x7c, 0x82, 0x2, 0x7c, 0x80, 0x80, 0xfe, 0,
	 0x7c, 0x82, 0x2, 0x7c, 0x2, 0x82, 0x7c, 0,
	 0x80, 0x84, 0x84, 0x84, 0xfe, 0x4, 0x4, 0,
	 0xfe, 0x80, 0x80, 0xfc, 0x2, 0x82, 0x7c, 0,
	 0x7c, 0x82, 0x80, 0xfc, 0x82, 0x82, 0x7c, 0,
	 0xfe, 0x84, 0x8, 0x10, 0x20, 0x20, 0x20, 0,
	 0x7c, 0x82, 0x82, 0x7c, 0x82, 0x82, 0x7c, 0,
	 0x7c, 0x82, 0x82, 0x7e, 0x2, 0x82, 0x7c, 0,
	 0x10, 0x38, 0x10, 0, 0x10, 0x38, 0x10, 0,
	 0x38, 0x38, 0, 0x38, 0x38, 0x10, 0x20, 0,
	 0x8, 0x10, 0x20, 0x40, 0x20, 0x10, 0x8, 0,
	 0, 0, 0x7c, 0, 0x7c, 0, 0, 0,
	 0x20, 0x10, 0x8, 0x4, 0x8, 0x10, 0x20, 0,
	 0x7c, 0x82, 0x2, 0x1c, 0x10, 0, 0x10, 0,
	 0x7c, 0x82, 0xba, 0xba, 0xbc, 0x80, 0x7c, 0,
	 0x10, 0x28, 0x44, 0x82, 0xfe, 0x82, 0x82, 0,
	 0xfc, 0x82, 0x82, 0xfc, 0x82, 0x82, 0xfc, 0,
	 0x7c, 0x82, 0x80, 0x80, 0x80, 0x82, 0x7c, 0,
	 0xfc, 0x82, 0x82, 0x82, 0x82, 0x82, 0xfc, 0,
	 0xfe, 0x80, 0x80, 0xf8, 0x80, 0x80, 0xfe, 0,
	 0xfe, 0x80, 0x80, 0xf8, 0x80, 0x80, 0x80, 0,
	 0x7c, 0x82, 0x80, 0x9e, 0x82, 0x82, 0x7c, 0,
	 0x82, 0x82, 0x82, 0xfe, 0x82, 0x82, 0x82, 0,
	 0x38, 0x10, 0x10, 0x10, 0x10, 0x10, 0x38, 0,
	 0x2, 0x2, 0x2, 0x2, 0x82, 0x82, 0x7c, 0,
	 0x84, 0x88, 0x90, 0xe0, 0x90, 0x88, 0x84, 0,
	 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xfe, 0,
	 0x82, 0xc6, 0xaa, 0x92, 0x82, 0x82, 0x82, 0,
	 0x82, 0xc2, 0xa2, 0x92, 0x8a, 0x86, 0x82, 0,
	 0xfe, 0x82, 0x82, 0x82, 0x82, 0x82, 0xfe, 0,
	 0xfc, 0x82, 0x82, 0xfc, 0x80, 0x80, 0x80, 0,
	 0x7c, 0x82, 0x82, 0x82, 0x8a, 0x84, 0x7a, 0,
	 0xfc, 0x82, 0x82, 0xfc, 0x88, 0x84, 0x82, 0,
	 0x7c, 0x82, 0x80, 0x7c, 0x2, 0x82, 0x7c, 0,
	 0xfe, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0,
	 0x82, 0x82, 0x82, 0x82, 0x82, 0x82, 0x7c, 0,
	 0x82, 0x82, 0x82, 0x82, 0x44, 0x28, 0x10, 0,
	 0x82, 0x92, 0x92, 0x92, 0x92, 0x92, 0x6c, 0,
	 0x82, 0x44, 0x28, 0x10, 0x28, 0x44, 0x82, 0,
	 0x82, 0x44, 0x28, 0x10, 0x10, 0x10, 0x10, 0,
	 0xfe, 0x4, 0x8, 0x10, 0x20, 0x40, 0xfe, 0,
	 0x7c, 0x40, 0x40, 0x40, 0x40, 0x40, 0x7c, 0,
	 0x80, 0x40, 0x20, 0x10, 0x8, 0x4, 0x2, 0,
	 0x7c, 0x4, 0x4, 0x4, 0x4, 0x4, 0x7c, 0,
	 0x10, 0x28, 0x44, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0xfe, 0,
	 0x38, 0x38, 0x10, 0x8, 0, 0, 0, 0,
	 0, 0x18, 0x24, 0x42, 0x7e, 0x42, 0x42, 0,
	 0, 0x7c, 0x42, 0x7c, 0x42, 0x42, 0x7c, 0,
	 0, 0x3c, 0x42, 0x40, 0x40, 0x42, 0x3c, 0,
	 0, 0x7c, 0x42, 0x42, 0x42, 0x42, 0x7c, 0,
	 0, 0x7e, 0x40, 0x7c, 0x40, 0x40, 0x7e, 0,
	 0, 0x7e, 0x40, 0x7c, 0x40, 0x40, 0x40, 0,
	 0, 0x3c, 0x42, 0x40, 0x4e, 0x42, 0x3c, 0,
	 0, 0x42, 0x42, 0x7e, 0x42, 0x42, 0x42, 0,
	 0, 0x8, 0x8, 0x8, 0x8, 0x8, 0x8, 0,
	 0, 0x2, 0x2, 0x2, 0x2, 0x42, 0x3c, 0,
	 0, 0x42, 0x44, 0x78, 0x48, 0x44, 0x42, 0,
	 0, 0x40, 0x40, 0x40, 0x40, 0x40, 0x7e, 0,
	 0, 0x42, 0x66, 0x5a, 0x42, 0x42, 0x42, 0,
	 0, 0x42, 0x62, 0x52, 0x4a, 0x46, 0x42, 0,
	 0, 0x3c, 0x42, 0x42, 0x42, 0x42, 0x3c, 0,
	 0, 0x7c, 0x42, 0x42, 0x7c, 0x40, 0x40, 0,
	 0, 0x3c, 0x42, 0x42, 0x4a, 0x44, 0x3a, 0,
	 0, 0x7c, 0x42, 0x42, 0x7c, 0x44, 0x42, 0,
	 0, 0x3c, 0x40, 0x3c, 0x2, 0x42, 0x3c, 0,
	 0, 0x3e, 0x8, 0x8, 0x8, 0x8, 0x8, 0,
	 0, 0x42, 0x42, 0x42, 0x42, 0x42, 0x3c, 0,
	 0, 0x42, 0x42, 0x42, 0x42, 0x24, 0x18, 0,
	 0, 0x42, 0x42, 0x42, 0x5a, 0x66, 0x42, 0,
	 0, 0x42, 0x24, 0x18, 0x18, 0x24, 0x42, 0,
	 0, 0x22, 0x14, 0x8, 0x8, 0x8, 0x8, 0,
	 0, 0x7e, 0x4, 0x8, 0x10, 0x20, 0x7e, 0,
	 0x38, 0x40, 0x40, 0xc0, 0x40, 0x40, 0x38, 0,
	 0x10, 0x10, 0x10, 0, 0x10, 0x10, 0x10, 0,
	 0x38, 0x4, 0x4, 0x6, 0x4, 0x4, 0x38, 0,
	 0x60, 0x92, 0xc, 0, 0, 0, 0, 0,
	 0, 0, 0, 0, 0, 0, 0, 0,
};

static void banner(const char *string,const char *delim,int width)
{
	register unsigned mask;
	register int c,i,n,j = strlen(string);
	register const char *cp,*dp;
	register unsigned char* map;
	
	map = ccmap(CC_NATIVE, CC_ASCII);
	if(j > width/8)
		error(ERROR_exit(1),"up to %d char%s per arg",width/8,(width/8)==1?"":"s");
	for(i=0; i < CHAR_HEIGHT; i++)
	{
		dp = delim;
		for (n = 0, cp = string; c = ccmapchr(map, *cp++) & 0x07f; dp++)
		{
			if(*dp==0)
				dp = delim;
			if((mask = bandata[c][i])==0)
			{
				n += 8;
				continue;
			}
			for(j=0x80; j>0; j >>=1)
			{
				if(mask&j)
				{
					if(n)
					{
						sfnputc(sfstdout,' ',n);
						n = 0;
					}
					sfputc(sfstdout,*dp);
				}
				else
					n++;
			}
		}
		sfputc(sfstdout,'\n');
	}
}

int
main(int argc, char *argv[])
{
	register int n;
	register char *cp;
	char *delim  = "#";
	int width = 80;

	NoP(argc);
	error_info.id = "banner";
	while (n = optget(argv, usage)) switch (n)
	{
	case 'd':
		delim = opt_info.arg;
		break;
	case 'w':
		width = opt_info.num; 
		break;
	case ':':
		error(2, "%s", opt_info.arg);
		break;
	case '?':
		error(ERROR_usage(2), "%s", opt_info.arg);
		break;
	}
	argv += opt_info.index;
	if(error_info.errors || !*argv)
		error(ERROR_usage(2), "%s", optusage((char*)0));
	sfset(sfstdout,SF_LINE,0);
	while(cp = *argv++)
		banner(cp,delim,width);
	exit(0);
}