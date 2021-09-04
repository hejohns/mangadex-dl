#!/usr/bin/env perl

use v5.28;
use utf8;

use strict;
use warnings;

use File::Spec;

my $downloads = './download';
opendir(my $download_dh, $downloads) or die "$!";
my @titles = grep {!/^\./} readdir $download_dh;
@titles = sort @titles;
closedir $download_dh;
foreach(@titles){
    my $title = $_;
    my $pathToTitle = File::Spec->catfile($downloads, $_);
    opendir(my $title_dh, $pathToTitle);
    my @chapters = grep {!/^\./} readdir $title_dh;
    @chapters = sort @chapters;
    closedir $title_dh;
    foreach(@chapters){
        my $chapter = $_;
        my $pathToChapter = File::Spec->catfile($pathToTitle, $_);
        opendir(my $chapter_dh, $pathToChapter);
        my @pages = grep {!/^\./} readdir $chapter_dh;
        @pages = sort @pages;
        closedir $chapter_dh;
        my @pathToPages = map {"'" . File::Spec->catfile($pathToChapter, $_) . "'"} @pages;
        say $title;
        say $chapter;
        `mkdir -p pdfs/'$title'`;
        my $pdf = File::Spec->catfile('pdfs', "'$title'", "'$title-$chapter'" . '.pdf');
        print `convert @pathToPages $pdf`;
    }
}
