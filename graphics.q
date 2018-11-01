displayCM:{[cm;classes;title;cmap]
 if[cmap~();cmap:plt`:cm.Blues];
 subplots:plt[`:subplots][`figsize pykw 5 5];
 fig:subplots[`:__getitem__][0];
 ax:subplots[`:__getitem__][1];

 ax[`:imshow][cm;`interpolation pykw `nearest;`cmap pykw cmap];
 ax[`:set_title][`label pykw title];
 tickMarks:til count classes;
 ax[`:xaxis.set_ticks][tickMarks];
 ax[`:set_xticklabels][classes];
 ax[`:yaxis.set_ticks][tickMarks];
 ax[`:set_yticklabels][classes];

 thresh:(max raze cm)%2;
 shp:shape cm;
 {[cm;thresh;i;j] plt[`:text][j;i;(string cm[i;j]);`horizontalalignment pykw `center;`color pykw $[thresh<cm[i;j];`white;`black]]}[cm;thresh;;]. 'cross[til shp[0];til shp[1]];
 plt[`:xlabel]["Predicted Label";`fontsize pykw 12];
 plt[`:ylabel]["Actual label";`fontsize pykw 12];
 fig[`:tight_layout][];
 plt[`:show][];
 } /plot confusion matrix

precdict:{
 accuracy:{(sum x`tp`tn)%sum x}x;
 errorRate:{(sum x`fp`fn)%sum x}x;
 precision:{x[`tp]%sum x`tp`fp}x;        /Precision          --pred pos rate
 recall:{x[`tp]%sum x`tp`fn}x;           /Recall/Sensitivity --true pos rate
 specificity:{x[`tn]%sum x`tn`fp}x;      /Specificity        --true neg rate
 TSS:0.01*{(x[`tp]%(sum x`tp`fn))-(x[`fp]%sum x`fp`tn)}x;
 `accuracy`errorRate`precision`recall`specificity`TSS!(accuracy;errorRate;precision;recall;specificity;TSS)
 } /create metrics dictionary

resplot:{[t1;t2;stn]

  plt[`:subplots][1;2;`figsize pykw 20 4];

  plt[`:subplot]121;
  plt[`:scatter][t1`chainStation;t1`TSS];
  plt[`:scatter][first t1`chainStation;first t1`TSS;`color pykw`black];
  plt[`:grid]1b;
  plt[`:ylim]0 1;
  plt[`:xlabel]"Chain Station";
  plt[`:ylabel]"Total Skill Score";
  plt[`:title]"Individual SVM Results";

  plt[`:subplot]122;
  plt[`:scatter][t2`chainStation;t2`TSS;`color pykw `darkorange];
  plt[`:scatter][stn;exec first TSS from t2 where chainStation=stn;`color pykw`black];
  plt[`:grid]1b;
  plt[`:ylim]0 1;
  plt[`:xlabel]"Chain Station";
  plt[`:ylabel]"Total Skill Score (TSS)";
  plt[`:title]"Fort McMurray SVM Results";

  plt[`:show][];

 } /TSS score of each station

rocplot:{[ytest;ypred]

 curve:roc[.1<exp ytest;exp ypred];
 fps:("f"$curve)0;  
 tps:("f"$curve)1;
 rocauc:rocaucscore[.1<exp ytest;exp ypred];

 plt[`:plot][fps;tps;`lw pykw 2;`label pykw"NN auc = ",(string rocauc)];
 plt[`:plot][0 1;0 1;`lw pykw 2;`linestyle pykw"--"];
 plt[`:xlim][0 1];
 plt[`:ylim][0 1.05];
 plt[`:xlabel]"False Positive Rate";
 plt[`:ylabel]"True Positive Rate";
 plt[`:title]" Receiver Operating Characteristics";
 plt[`:legend][`loc pykw"lower right"];
 plt[`:show][];

 } /plot ROC curve

scintplot:{

 plt[`:subplots][3;1;`figsize pykw 6 6];
 plt[`:subplot]311;
 plt[`:plot][1000#4600_x`sigPhiVer;`color pykw`darkblue;`label pykw`sigPhiVer];
 plt[`:ylabel]"SigPhiVer [radians]";
 plt[`:xticks][() ()];
 plt[`:legend][];
 plt[`:title]"Feature variation during scintillation event";

 plt[`:subplot]312;
 plt[`:plot][1000#4600_x`dTEC_15s;`color pykw`r;`label pykw`dTEC_15s];
 plt[`:ylabel]"dTEC [TECU]";
 plt[`:xticks][() ()];
 plt[`:legend][];

 plt[`:subplot]313;
 plt[`:plot][1000#4600_x`xcomp;`color pykw`g;`label pykw`xcomp];
 plt[`:ylabel]"x comp [nT]";
 plt[`:xlabel]"Timestep";
 plt[`:legend][];

 plt[`:tight_layout][];
 plt[`:show][];

 } /scintillation plot
