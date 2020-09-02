%% run individual mcmc
%normal
addpath('./bin');
load('./data/lb_ub_for_PQMM');
modelnames = sampleInfo(:,1);
pars = parse_parsfile('pars.txt');
changeCobraSolver(pars.cobrasolver);
for i = 1:length(modelnames)
     tname = ['./Mat_PQM/MCMC',modelnames{i},'_1.mat'];
     if exist(tname)
       continue;
     end
    load(['./Mat_PQM/',modelnames{i},'.mat']);
    idatp = findRxnIDs(outmodel,'DM_atp_c_');
    outmodel.lb(idatp) = outmodel.ub(idatp)*0.9;
    idbiomass  = findRxnIDs(outmodel,'biomass_reaction');
    sol= optimizeCbModel(outmodel);
    outmodel.lb(idbiomass)  = sol.f*0.9;
    outmodel.ub(idbiomass)  = sol.f;
    xx = FastMCMC_cplex(outmodel,pars.numPoints,1000,tname);
end
exit;