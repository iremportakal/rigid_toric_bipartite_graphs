use application 'polytope';
use application 'fulton';
load_singular_library("sing.lib");

sub T1_module {
    my($cone) = @_;
    # Calculate the toric ideal and its generators
    my $toric_ideal = $cone->TORIC_IDEAL;
    my $ti_gens = $toric_ideal->GENERATORS;
    my $cmd = "ideal toric_ideal =".join(",",@$ti_gens).";";

    # Use groebner basis to set up the polynomial ring in Singular
    my $G = $toric_ideal->add("GROEBNER", ORDER_NAME=>"dp");
    my $Gbasis = $G->BASIS;

    print "Edge ideal generators related to G\n\n";
    singular_eval($cmd);
    singular_eval("toric_ideal;");

    print "\nGenerators of the module of infinitisimal deformations of TV(G)\n\n";
    singular_eval("module M = T_1(toric_ideal);");
    singular_eval("M;");

    print "\nThe dimension of M as a module\n\n";
    singular_eval("dim(M);");

    print "\nThe dimension of M as a vector space\n\n";
    singular_eval("vdim(M);");
}
