# --
# Kernel/Output/HTML/OutputFilterMoveLogoutButton.pm
# Copyright (C) 2014 Perl-Services.de, http://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterMoveLogoutButton;

use strict;
use warnings;

use List::Util qw(first);

our @ObjectDependencies = qw(
    Kernel::Config
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Template = $Param{TemplateFile};
    return 1 if !$Template;
    return 1 if !$Param{Templates}->{$Template};

    my $ShowUsername = $Kernel::OM->Get('Kernel::Config')->Get('MoveLogoutButton::ShowUsername');

    ${ $Param{Data} } =~ s{(
        <ul \s* id="ToolBar"> .*?
    ) (
        (?: <li> .*? </li> \s* ){2}
        </ul>
    )}{$1 . "</ul>" . _Infofy( $2, $ShowUsername )}exsm;

    return ${ $Param{Data} };
}

sub _Infofy {
    my ($Items, $ShowUsername) = @_;

    my @Icons = $Items =~ m{<li> (.*?) </li>}xmsg;

    my $User = '';
    if ( $ShowUsername ) {
        ($User) = $Items =~ m{
            class="LogoutButton" [^>]+
            title=".*? \s+ \(([^"]+)\)"
        }xms;

        $User = '<span>' . $User . '</span>';
    }

    sprintf qq~<div id="UserInfo">%s%s%s</div>~, $User, @Icons;
}

1;
