Maxim maxim;
AudioPlayer n[], l[], c[];

float cubeposX[], cubeposY[];
boolean cubedeploy, gameset, gameplay, mainmenu;
PFont font;
int level;
boolean standard,letters,colors,symbols,visual,vismask,audio,rule,inverse;
char charray[] = {'A','B','C','D','E','F','G','H','I'};
char charrayDIS[] = {'B','F','H','J','L','M','R','S','X'};
char charraySIM[] = {'B','C','D','G','P','Q','T','V','Z'};
char symbolsarr[] = {'%','!',';','/','»','*','#','~','{'};
float stimulus_timer, mask_timer;
boolean define_span;
int span[], sequence, response[], res_num, correct, incorrect, cons_cor, cons_inc;
boolean noplay, define_new_span;
int cond_rsp, newspan_num, newspan[], ellin, elliarr[], rectarr[], rectn;

PrintWriter record_data;
boolean start_recording;
int trial_record;

void setup(){
 size(displayWidth,displayHeight);
 orientation(LANDSCAPE);
 ellipseMode(CENTER);
 rectMode(CENTER);
 imageMode(CENTER);
 textAlign(CENTER, CENTER);
 shapeMode(CENTER);
 
 maxim = new Maxim(this);
 
 n = new AudioPlayer [9];
 l = new AudioPlayer [9];
 c = new AudioPlayer [9];
 
 noplay = false;
 
 for(int i = 0; i < 9; i++)
 {
   n[i] = maxim.loadFile("Stimulus/Numeros/"+i+".wav");
   n[i].setLooping(false);
   n[i].volume(2.0);
   
   l[i] = maxim.loadFile("Stimulus/Letras/"+i+".wav");
   l[i].setLooping(false);
   l[i].volume(2.0);
   
   c[i] = maxim.loadFile("Stimulus/Cores/"+i+".wav");
   c[i].setLooping(false);
   c[i].volume(2.0);
 }
 
 mainmenu = true;
 gameset = gameplay = cubedeploy = false;
 
 cubeposX = new float [9];
 cubeposY = new float [9];
 
 letters = false;
 standard = true;
 colors = false;
 symbols = false;
 
 visual = true;
 vismask = false;
 audio = false;
 
 rule = false;
 inverse = false;
 
 stimulus_timer = 0.0;
 mask_timer = 0.0;
 define_span = false;
 span = new int [10];
 sequence = 0;
 res_num = 0;
 correct = incorrect = 0;
 cons_cor = cons_inc = 0;
 
 cond_rsp = 0;
 define_new_span = true;
 elliarr = new int [9];  
 rectarr = new int [9];
 
 level = 0;
 
 background(180);
 
 font = createFont("BebasNeue.otf",1,true);
 textFont(font);
 //smooth();
 
 //print stuff  
 record_data = createWriter("Sessão.txt");
 
 int day = day();
 int month = month();
 int year = year();
 
 record_data.println("**********"+day+"/"+month+"/"+year+"**********");
 record_data.flush();
 start_recording = true;
 
 trial_record = 1;
}


void draw(){
  if(mainmenu)  //Escolha das preferencias do jogo
  {      
    stroke(1);
    if(!standard) fill(255);
    else fill(0,0,255);  
    rect(width*.15, height/5 + width*.02, width*.2, width*.05);
    if(!letters) fill(255);
    else fill(0,0,255); 
    rect(width*.15, 2*height/5 + width*.02, width*.2, width*.05);
    if(!symbols) 
    {
      if(!audio && !rule) fill(255);
      else fill(0,0,0,5);
    }
    else fill(0,0,255); 
    rect(width*.15, 3*height/5 + width*.02, width*.2, width*.05);
    if(!colors) fill(255);
    else fill(0,0,255); 
    rect(width*.15, 4*height/5 + width*.02, width*.2, width*.05);
    
    if(!visual) fill(255);
    else fill(0,0,255); 
    rect(width*.5, 2*height/5 + width*.02, width*.2, width*.05);
    if(!vismask) fill(255);
    else fill(0,0,255); 
    rect(width*.5, 3*height/5 + width*.02, width*.2, width*.05);
    if(!audio) fill(255);
    else fill(0,0,255); 
    rect(width*.5, 4*height/5 + width*.02, width*.2, width*.05);
    
    if(rule) fill(255);
    else fill(0,0,255); 
    rect(width*.85, height/5 + width*.02, width*.2, width*.05);
    if(!rule) fill(255);
    else fill(0,0,255); 
    rect(width*.85, 1.5*height/5 + width*.02, width*.2, width*.05);
    
    if(inverse) fill(255);
    else fill(0,0,255); 
    rect(width*.85, 3.5*height/5 + width*.02, width*.2, width*.05); 
    if(!inverse) fill(255);
    else fill(0,0,255); 
    rect(width*.85, 4*height/5 + width*.02, width*.2, width*.05); 
    
    textSize(width*.02);
    fill(0);
    
    text("Standard",width*.15, height/5 + width*.02);
    text("Letras",width*.15, 2*height/5 + width*.02);
    text("Símbolos",width*.15, 3*height/5 + width*.02);
    text("Cores",width*.15, 4*height/5 + width*.02); 
    
    text("Visual s/ Máscara", width*.5, 2*height/5 + width*.02);
    text("Visual c/ Máscara", width*.5, 3*height/5 + width*.02);
    text("Auditiva", width*.5, 4*height/5 + width*.02);
    
    text("s/ Regra", width*.85, height/5 + width*.02);
    text("c/ Regra", width*.85, 1.5*height/5 + width*.02);
    
    text("Normal", width*.85, 3.5*height/5 + width*.02);
    text("Inversa", width*.85, 4*height/5 + width*.02);
    
    textSize(width*.06);
    //fill(0,0,255);
    text("Cogni-Corsi", width/2, width*.03);
    
    textSize(width*.0225);
    text("©Araújo & Casqueiro (2015)",width*.11, width*.01125);
    textSize(width*.02);
    text("v1.0", width - width*.02, width*.009);
    
    textSize(width*.03);
    //fill(0,255,0);
    text("Pistas",width*.15, height/8 + width*.02);
    text("Modalid/ Instrução",width*.5, 2*height/6.25 + width*.02);
    text("Condição de Resposta", width*.85, height/8 + width*.02);
    text("Ordem de Resposta", width*.85, height/1.6 + width*.02);
    
    textSize(width*.045);
    fill(0,0,255);
    text("Começar", width*.5, height/5 + width*.02);
    noFill();
    //rect(width*.5, height/5 + width*.02, width*.2, width*.1); //RECTANGULO PARA MOUSECLICK
  }
  
  
  textSize(width*.018);
  if(cubedeploy && !gameset) // Deposição aleatória dos cubos
  {
    ellin = 0;
    rectn = 0;
    background(180);
    stroke(0);
    
   /* int n_tri[];
    if(random(4,5.9) == 4) n_tri = new int [4];
    else n_tri = new int [5];*/
    
    for(int i = 0; i<9; i++)
    {
      fill(255);
      cubeposX[i] = random(width*.08,width-(width*.08));
      cubeposY[i] = random(height*.2 + (width*.08),height-(width*.08));
      
      if(i>0) // Anti-overlap
        for(int j = 0; j<i; j++)
          if(cubeposX[i] < cubeposX[j] + width*.08 && cubeposX[i] > cubeposX[j] - width*.08)
            while(cubeposY[i] < cubeposY[j] + width*.08 && cubeposY[i] > cubeposY[j] - width*.08)
            {
              cubeposX[i] = random(width*.08,width-(width*.08));
              cubeposY[i] = random(height*.2 +(width*.08),height-(width*.08));
              j = 0;      
              //print("\nRepositioning one cube");        
            }
      
      if(colors)
      {
        if(i == 0) fill(0,255,0);     //verde
        if(i == 1) fill(255,0,0);     //vermelho
        if(i == 2) fill(250,230,5);   //amarelo
        if(i == 3) fill(0,0,255);     //azul
        if(i == 4) fill(255,130,0);   //laranja
        if(i == 5) fill(125,65,19);   //castanho
        if(i == 6) fill(135,62,162);  //roxo
        if(i == 7) fill(247,11,121);  //rosa
        if(i == 8) fill(154,140,140); //cinza
      }
      
      if(!rule || !colors) rect(cubeposX[i], cubeposY[i], width*.075, width*.075);
      
      if(rule && colors) // definiçao do span de quadrados e circulos para condiçao cores com regras
      {
        if( (int) random(1.9) == 0 )
        {
          rect(cubeposX[i], cubeposY[i], width*.075, width*.075);
          rectarr[rectn] = i;
          rectn++;
        }
        else{
          ellipse(cubeposX[i], cubeposY[i], width*.075, width*.075);
          elliarr[ellin] = i;
          ellin++;          
        }
      }
      
      fill(0);
      
      if(standard) text(""+(i+1),cubeposX[i],cubeposY[i]);
      if(letters)  text(""+charray[i], cubeposX[i], cubeposY[i]);
      if(symbols)  text(""+symbolsarr[i], cubeposX[i], cubeposY[i]);  
    }
    
    strokeWeight(width*.002);
    stroke(0);
    line(0,height*.2,width,height*.2);
    strokeWeight(1);
    
    textSize(width*.05);
    text("Nível "+level, width*.5, height*.05);
    
    noFill();
    rect(width - width*.08,height*.1,width*.15,width*.1);
    rect(width*.08,height*.1,width*.15,width*.1);
    
    textSize(width*.03);
    text("Próximo", width - width*.08, height*.1);
    
    text("Menu Inicial", width*.08, height*.1);
    
    cubedeploy = false;
    gameset = true;
    define_span = true;
    
    if(rule && colors && (ellin == 0 || rectn == 0))
    {
      cubedeploy = true;
      gameset = false;
      define_span = false;
      //println("Reloading cubes\n");
    }
    
    else
    {
      if(start_recording)
      {
        record_data.println();
        record_data.println("********************");
        record_data.print("Pista: ");
        if(standard) record_data.println("Números");
        if(letters) record_data.println("Letras");
        if(symbols) record_data.println("Símbolos");
        if(colors) record_data.println("Cores");
        record_data.print("Instrução: ");
        if(visual) record_data.println("Visual");
        if(vismask) record_data.println("Visual com máscara");
        if(audio) record_data.println("Auditiva");
        record_data.print("Regra: ");
        if(rule) record_data.println("Sim");
        else record_data.println("Não");
        record_data.print("Ordem: ");
        if(inverse) record_data.println("Inversa");
        else record_data.println("Directa");
        record_data.println("********************");
        record_data.println();
        record_data.flush();
        start_recording = false;
      }
    
    }
  
  }
  
  if(gameset)   //Apresentação dos estímulos
  {
   
    if(define_span) 
    {
      span = new int [level+3];
      print("Span: ");
      for(int i = 0; i < span.length; i++)
      {
        span[i] = (int) random(0,8.5); //int arredonda por defeito sempre
        
        //println(span.length);
        print(span[i]+1);   
        
      }
      
      define_span = false;
    }
      
      if(rule) //definimos as regras de resposta condicionada para letras e numeros e cores aqui
      {
       if(define_new_span)
       {
         cond_rsp = (int) random(100) % 2;
        // print("Conditioned Response is "+cond_rsp);
         newspan_num = 0;
         
         newspan = new int [10];
         println(ellin,rectn);      
          
         for(int i = 0; i < span.length; i++)
         { 
           if(standard)        
             if((cond_rsp == 1 && span[i] % 2 != 0 )|| ( cond_rsp == 0 && span[i] % 2 == 0 ) )
               {
                 newspan[newspan_num] = span[i];
                 newspan_num++; 
               }  
            
            if(letters)
             if((cond_rsp == 1 && (span[i] == 1 /*b*/ || span[i] == 2 /*c*/ || span[i] == 3 /*d*/ || span[i] == 5 /*f*/ || span[i] == 6 /*g*/ || span[i] == 7 /*h*/) )
               || ( cond_rsp == 0 &&( span[i] == 0 /*a*/ || span[i] == 4 /*e*/ || span[i] == 8 /*i*/) ) )      
               {
                 newspan[newspan_num] = span[i];
                 newspan_num++; 
               }

             if(colors)
             {
               if(cond_rsp == 0) 
                 for(int j = 0; j < ellin; j++)
                  if(span[i] == elliarr[j]) 
                   {
                       newspan[newspan_num] = span[i];
                       newspan_num++;
                       //print("\n Zero Condition");
                       break; 
                   }
                   
                 if(cond_rsp == 1)
                   for(int j = 0; j < rectn; j++)
                     if(span[i] == rectarr[j])
                     {
                       newspan[newspan_num] = span[i];
                       newspan_num++; 
                       //print("\n One Condition");
                       break;
                     }
                }
             }      
          }
         
         if(newspan_num > 0) define_new_span = false;
         
         if(newspan_num == 0) define_span = true;    
      }
      
      if(stimulus_timer == 0.0) stimulus_timer = millis();
       //print("millis - stimulus = "+(millis() - stimulus_timer)+"\n");
    
      if(((millis() - stimulus_timer) <= 500 && sequence != 0) || (millis() - stimulus_timer) > 500 && sequence == 0 && (millis() - stimulus_timer) <= 1000)
      {
        if(!audio)
        {
          noStroke();
          fill(0,0,255);
          if(!colors) rect(cubeposX[span[sequence]],cubeposY[span[sequence]], width*.07, width*.07);
          if(colors)
          {
            fill(255);
            ellipse(cubeposX[span[sequence]],cubeposY[span[sequence]], width*.035, width*.035);
          }
          //println(cubeposX[span[sequence]]);
          fill(0);
          if(standard) text(""+(span[sequence]+1),cubeposX[span[sequence]],cubeposY[span[sequence]]);
          if(letters) text(""+(charray[span[sequence]]),cubeposX[span[sequence]],cubeposY[span[sequence]]); 
          if(symbols) text(""+(symbolsarr[span[sequence]]),cubeposX[span[sequence]],cubeposY[span[sequence]]);
        }
        
        if(audio && !noplay)
        {
          if(standard)
          {
            n[span[sequence]].cue(0);
            n[span[sequence]].play();     
          }
          
          if(letters)
          {
            l[span[sequence]].cue(0);
            l[span[sequence]].play();             
          }

          if(colors)
          {
            c[span[sequence]].cue(0);
            c[span[sequence]].play();             
          }          
          noplay = true;
        }
         
      }
      
      if(((millis() - stimulus_timer) > 1000 && (millis() - stimulus_timer) < 1500 && sequence == 0) || (millis() - stimulus_timer) > 500 && (millis() - stimulus_timer) < 1000 && sequence != 0)
      {
        if(!colors) stroke(255); // margem
        fill(255);
        
        if(colors)
        {
          if(span[sequence] == 0){ fill(0,255,0); stroke(0,255,0); } //verde
          if(span[sequence] == 1){ fill(255,0,0); stroke(255,0,0); }//vermelho
          if(span[sequence] == 2){ fill(250,230,5); stroke(250,230,5);} //amarelo
          if(span[sequence] == 3){ fill(0,0,255); stroke(0,0,255); }//azul
          if(span[sequence] == 4){ fill(255,130,0); stroke(255,130,0);} //laranja
          if(span[sequence] == 5){ fill(125,65,19); stroke(125,65,19);} //castanho
          if(span[sequence] == 6){ fill(135,62,162); stroke(135,62,162);} //roxo
          if(span[sequence] == 7){ fill(247,11,121); stroke(247,11,121); }//rosa
          if(span[sequence] == 8){ fill(154,140,140); stroke(154,140,140);} //cinza  
        }
        
        if(!colors)rect(cubeposX[span[sequence]],cubeposY[span[sequence]], width*.07, width*.07);
        if(colors) ellipse(cubeposX[span[sequence]],cubeposY[span[sequence]], width*.07, width*.07);
        
        fill(0);        
        if(standard) text(""+(span[sequence]+1),cubeposX[span[sequence]],cubeposY[span[sequence]]);
        if(letters) text(""+(charray[span[sequence]]),cubeposX[span[sequence]],cubeposY[span[sequence]]);
        if(symbols) text(""+(symbolsarr[span[sequence]]),cubeposX[span[sequence]],cubeposY[span[sequence]]);       
      }
  
        if((millis() - stimulus_timer) >= 1500 && sequence == 0 || (millis() - stimulus_timer) >= 1000 && sequence != 0)
        {
          stimulus_timer = 0.0;
          if(sequence < level + 3) sequence++; 
          if(audio) noplay = false;
          //print("Replacing timer\n");
        }       
      
     if(sequence == span.length)
     {               
         if(!rule) response = new int [span.length];
         else{
           response = new int [newspan_num];
           span = new int [newspan_num];
         
           for(int i = 0; i < span.length; i++)
             span[i] = newspan[i]; 
             
             /*println("\nSpan & Response array redefined\n");
             for(int i = 0; i< elliarr.length; i++)
               print(elliarr[i]);
               print("\n");
             for(int i = 0; i< rectarr.length; i++)
               print(rectarr[i]);
               print("\n");
             for(int i = 0; i < span.length; i++)
               print(span[i]);*/
         }             
         gameset = false;
         gameplay = true;
         mask_timer = millis();
                 // noLoop();*/
     }
  }
  
  if(gameplay){
     if(vismask)
     {
         if((millis() - mask_timer) <= 500)
         {
           fill(0);
           stroke(0);
           rect(width*.5,height*.5+height*.1-width*.001,width,height-(height*.2 + width*.003));
           fill(255);
           textSize(width*.05);
           text("ZZZZZZZZZZZZZ",width*.5,height*.5); 
         }      
       }
     
     if(millis() - mask_timer > 500)
     {
     fill(180);
     sequence = 0;
     rect(width*.5,height*.5+height*.1-width*.001,width,height-(height*.2 + width*.003));
     
     for(int i = 0; i < 9; i++)
         {
           fill(255);
           stroke(0);
           if(mouseX >= cubeposX[i] - width*.075/2 && mouseX < cubeposX[i] + width*.075/2 && mouseY > cubeposY[i] - width*.075/2 && mouseY < cubeposY[i] + width*.075/2)
           {
            if(mousePressed) fill(0,0,255);
            else fill(0,0,255,100);
           }
           rect(cubeposX[i],cubeposY[i], width*.075, width*.075);
         } 
         
     fill(0,0,255);
     textSize(width*.03);
     if(!rule && !inverse)                             text("Sequência?", width*.5, height*.15);
     if(!rule && inverse)                              text("Sequência Inversa?", width*.5, height*.15);
     if(rule && cond_rsp == 0 && standard && !inverse )text("Sequência de Ímpares?", width*.5, height*.15);
     if(rule && cond_rsp == 0 && standard && inverse ) text("Sequência Inversa de Ímpares?", width*.5, height*.15);
     if(rule && cond_rsp == 1 && standard && !inverse) text("Sequência de Pares?", width*.5, height*.15);
     if(rule && cond_rsp == 1 && standard && inverse ) text("Sequência Inversa de Pares?", width*.5, height*.15);
     if(rule && cond_rsp == 1 && letters && !inverse ) text("Sequência de Consoantes?", width*.5, height*.15);
     if(rule && cond_rsp == 1 && letters && inverse )  text("Sequência Inversa de Consoantes?", width*.5, height*.15);
     if(rule && cond_rsp == 0 && letters && !inverse ) text("Sequência de Vogais?", width*.5, height*.15);
     if(rule && cond_rsp == 0 && letters && inverse )  text("Sequência Inversa de Vogais?", width*.5, height*.15);
     if(rule && cond_rsp == 0 && colors && !inverse)   text("Sequência de Círculos?", width*.5, height*.15);
     if(rule && cond_rsp == 0 && colors && inverse )   text("Sequência Inversa de Círculos?", width*.5, height*.15);
     if(rule && cond_rsp == 1 && colors && !inverse )  text("Sequência de Quadrados?", width*.5, height*.15);
     if(rule && cond_rsp == 1 && colors && inverse )   text("Sequência Inversa de Quadrados?", width*.5, height*.15);
     
     if(res_num == response.length)
       for(int i = 0; i < response.length; i++)
       {
         if(!inverse)
         {
           if(response[i] == span[i] && incorrect+correct < response.length) correct++;
           if(response[i] != span[i] && incorrect+correct < response.length) incorrect++;
         }
         
         if(inverse)
         {
           if(response[i] == span[(response.length-1)-i] && incorrect+correct < response.length) correct++;
           if(response[i] != span[(response.length-1)-i] && incorrect+correct < response.length) incorrect++;           
         }
         
         if(correct+incorrect == response.length)
         {           
           if(correct == response.length)
           {
            fill(0,255,0);
            text("CERTO!", width/2, height/2);
           } 
           else
           {
             fill(255,0,0);
             text("ERRADO!", width/2, height/2);
           } 
         }      
       }
     }    
  }
}

void mouseClicked(){
  if(mainmenu)
  {
    // Pistas
    if(mouseX > width*.5 - width*.2/2 && mouseX < width*.5 + width*.2/2 && mouseY > (height/5 + width*.02) - width*.1/2 && mouseY < (height/5 + width*.02) + width*.1/2)
    {
      mainmenu = false;
      cubedeploy = true; 
    }
    
    if(mouseX > width*.15 - width*.2/2 && mouseX < width*.15 + width*.2/2 && mouseY > (height/5 + width*.02) - width*.1/4 && mouseY < (height/5 + width*.02) + width*.1/4)
    {
       standard = true;
       letters = false;
       colors = false;
       symbols = false;  
    }
    
    if(mouseX > width*.15 - width*.2/2 && mouseX < width*.15 + width*.2/2 && mouseY > (2*height/5 + width*.02) - width*.1/4 && mouseY < (2*height/5 + width*.02) + width*.1/4)
    {
       standard = false;
       letters = true;
       colors = false;
       symbols = false;  
    }

    if(mouseX > width*.15 - width*.2/2 && mouseX < width*.15 + width*.2/2 && mouseY > (3*height/5 + width*.02) - width*.1/4 && mouseY < (3*height/5 + width*.02) + width*.1/4 && !audio && !rule)
    {
       standard = false;
       letters = false;
       colors = false;
       symbols = true;  
    }    

    if(mouseX > width*.15 - width*.2/2 && mouseX < width*.15 + width*.2/2 && mouseY > (4*height/5 + width*.02) - width*.1/4 && mouseY < (4*height/5 + width*.02) + width*.1/4)
    {
       standard = false;
       letters = false;
       colors = true;
       symbols = false;  
    } 
 
    //Modalid/ Instrução   
     if(mouseX > width*.5 - width*.2/2 && mouseX < width*.5 + width*.2/2)
     {
       if(mouseY > (2*height/5 + width*.02) - width*.1/4 && mouseY < (2*height/5 + width*.02) + width*.1/4)
       {
         visual = true;
         vismask = false;
         audio = false;       
       }
     
       if(mouseY > (3*height/5 + width*.02) - width*.1/4 && mouseY < (3*height/5 + width*.02) + width*.1/4)
       {
         visual = false;
         vismask = true;
         audio = false;       
       }

       if(mouseY > (4*height/5 + width*.02) - width*.1/4 && mouseY < (4*height/5 + width*.02) + width*.1/4)
       {
         visual = false;
         vismask = false;
         audio = true; 
         if(symbols)
         {
           symbols = false;
           standard = true;
         }      
       }
     }
     
     //Regras e Resposta
     if(mouseX > width*.85 - width*.2/2 && mouseX < width*.85 + width*.2/2)
     {
      if(mouseY > (height/5 + width*.02) - width*.1/4 && mouseY < (height/5 + width*.02) + width*.1/4)
        rule = false;
      if(mouseY > (1.5*height/5 + width*.02) - width*.1/4 && mouseY < (1.5*height/5 + width*.02) + width*.1/4)
      {
        rule = true;
        
        if(symbols) 
        {
          symbols = false;
          standard = true;
        } 
      }
      
      if(mouseY > (3.5*height/5 + width*.02) - width*.1/4 && mouseY < (3.5*height/5 + width*.02) + width*.1/4)
        inverse = false;
      if(mouseY > (4*height/5 + width*.02) - width*.1/4 && mouseY < (4*height/5 + width*.02) + width*.1/4)
        inverse = true;       
     }     
  }
  
}

void mouseReleased(){
  if(!mainmenu && gameplay) 
  {
    if(mouseX > (width - width*.08) - width*.15/2 && mouseX < (width - width*.08) + width*.15/2 && mouseY > height*.1 - width*.1/2 && mouseY < height*.1 + width*.1/2)
    {
      background(180);
      gameset = false;
      cubedeploy = true;
      gameplay = false;
      stimulus_timer = 0.0;
      mask_timer = 0.0;
      sequence = 0;
      define_new_span = true;
      
      for(int i = 0; i < 9; i++) cubeposX[i] = cubeposY[i] = 0;
      
          //print stuff
      
           record_data.print(hour()+":"+minute()+":"+second()+", Ensaio "+trial_record+", Nível "+level+", Span apresentado: ");
           trial_record++;
           int j = 0;
           while (j < span.length)
           {
             record_data.print(span[j]);
             if(j + 1 != span.length) record_data.print("-");
             j++;
           }
           
           j = 0;
           record_data.print(", Resposta: ");
           
           while (j < response.length)
           {
             record_data.print(response[j]);
             if(j + 1 != response.length) record_data.print("-");
             j++;             
           }
           
           record_data.print(", ");
      
      if(correct == response.length) 
      {
        record_data.println("Acerto");
        cons_inc = 0;
        cons_cor++;
        if(level < 8 && cons_cor == 2)
        {
          level++;
          cons_cor = 0;
        }
      }
      
      else
      {
        record_data.println("Erro");
        cons_cor = 0;
        cons_inc++; 
        if(cons_inc == 2)
        {
                background(180);
                gameset = false;
                cubedeploy = false;
                gameplay = false;
                mainmenu = true;
                stimulus_timer = 0.0;
                mask_timer = 0.0;
                sequence = 0;
                res_num = 0;
                correct = incorrect = 0;
                cons_cor = cons_inc = 0;
                define_new_span = true;
                level = 0;
      
      for(int i = 0; i < 9; i++) cubeposX[i] = cubeposY[i] = 0;    
     
      start_recording = true;
      trial_record = 1;        
        }
      }
      
      record_data.flush();
      
      print("Consecutive correct "+cons_cor+"\n");
      print("Consecutive incorrect "+cons_inc+"\n");
      
      correct = incorrect = 0;
      res_num = 0;
      
      for(int i = 0; i < span.length; i++) span[i] = 0;
      
    } 
    
    if(res_num < response.length)
    {
      for(int i = 0; i < 9; i++)
        if(mouseX >= cubeposX[i] - width*.075/2 && mouseX <= cubeposX[i] + width*.075/2 && mouseY >= cubeposY[i] - width*.075/2 && mouseY <= cubeposY[i] + width*.075/2)
        {
           response[res_num] = i;
           println(response[res_num] + 1); 
           res_num++;       
        }
     } 
  }
  
  if(gameplay || gameset)
      if(mouseX > width*.08 - width*.15/2 && mouseX < width*.08 + width*.15/2 && mouseY > height*.1 - width*.1/2 && mouseY < height*.1 + width*.1/2)
    {
      background(180);
      gameset = false;
      cubedeploy = false;
      gameplay = false;
      mainmenu = true;
      stimulus_timer = 0.0;
      mask_timer = 0.0;
      sequence = 0;
      res_num = 0;
      correct = incorrect = 0;
      cons_cor = cons_inc = 0;
      define_new_span = true;
      level = 0;
      
      for(int i = 0; i < 9; i++) cubeposX[i] = cubeposY[i] = 0;    
     
      start_recording = true;
      trial_record = 1; 
    }
  
}


