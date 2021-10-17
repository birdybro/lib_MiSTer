/*
 * pad file with CR
 */
#include <stdio.h>


main( int argc, char *argv[] )
{
   FILE *in_fp, *out_fp;
   int ch, i;

   if( argc != 3)
   {
     printf( "\n usage: makehex <infile> <outfile>" );
     exit(0);
   }
   if( (in_fp=fopen( argv[1], "r" ))== NULL )
   {
     printf( "can't open %s for read", argv[1] );
     exit(0);
   }
   if((out_fp=fopen( argv[2], "w")) == NULL )
   {
     printf( "can't open %s for write", argv[2] );
     exit(0);
   }
   i = 0;
   while( (ch = getc( in_fp )) != -1 )
   {
      fprintf( out_fp, "%02x", ch );
      i++;
      if( (i % 16) == 0)
         fprintf( out_fp, "\n" );
   }
   printf( "\n %d bytes converted \n", i );
   fclose( in_fp);
   fclose( out_fp);
}
 
