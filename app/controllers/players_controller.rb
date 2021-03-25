class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def show
    @player = Player.find(params[:id])
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    @player.count=1
    @player.gameover=false
    @player.remaining=10
    @player.score=0
    if @player.save
      redirect_to @player
    else
      render :new
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    if @player.update(player_params)
      redirect_to @player
      @player.notice=""
      if (@player.throw>@player.remaining)
        @player.notice="Retry!!! Throw between 0-#{@player.remaining}"
      else  
        if @player.cell1==nil
          if @player.throw==10 
            if @player.strike1 == nil
              @player.strike1 = true
              if @player.score == nil
                @player.st1_score=10
                @player.score = 10
              else 
                if @player.spare==true   
                  @player.score+=10        
                  if @player.count==10     
                    @player.cell1=10
                    @player.score+=10
                    @player.spare=nil
                  else 
                    @player.st1_score=@player.score+10
                    @player.score=@player.st1_score    
                    @player.spare=nil
                  end  
                else
                  if @player.count==10             
                    @player.cell1=10
                    @player.st1_score=@player.score   
                    @player.score+=10
                  else                    
                    @player.st1_score=@player.score+10
                    @player.score+=10                      
                  end
                end 
              end
              @player.st1_count=1 
              if @player.count!=10
                @player.count+=1 
              end
            elsif @player.strike2 == nil
              @player.strike2 = true
              @player.st1_score+=10
              if @player.count==10
                @player.cell1=10
              else  
                @player.st2_score=@player.st1_score+10
                @player.score=@player.st2_score
                @player.st1_count=2
                @player.st2_count=1 
                @player.count+=1 
              end 
            else
              @player.st1_score+=10
              @player.st2_score=@player.st1_score+20
              if @player.count==10
                @player.cell1=10
              else
                @player.count+=1
              end 
                @player.st3_score=@player.st2_score+10
                @player.score=@player.st3_score
                @player.st1_score=@player.st2_score
                @player.st2_score=@player.st3_score
            end
          else                                                   
            @player.remaining=10-@player.throw
            @player.cell1=@player.throw
            if @player.strike1==true && @player.strike2==true
              if @player.count==10
                @player.st1_score=@player.st2_score+@player.cell1*2
                @player.st2_score=@player.st1_score+@player.cell1
                @player.score=@player.st1_score+@player.cell1
              end
            elsif @player.strike1==true 
              if @player.count!=10                                        
              else
                @player.st1_score+=@player.cell1
              end                                                          
            end  
          end                                                     
        elsif @player.cell2==nil
          @player.remaining=10
          if @player.spare==true
            @player.score+=@player.cell1
            @player.spare=nil
          end 
          @player.cell2=@player.throw 
          if @player.strike1==true && @player.strike2==true
            if @player.count!=10
              @player.st1_score+=@player.cell1
              @player.st2_score+=(@player.cell1*2)+@player.cell2
              @player.score=@player.st2_score+@player.cell1+@player.cell2
            else
              @player.st1_score+=@player.cell2
              @player.st2_score=@player.st1_score+@player.cell1+@player.cell2
              @player.score=@player.st2_score
            end  
            @player.throw=nil 
            @player.strike1=nil
            @player.strike2=nil
            @player.st1_score=0    
            @player.st2_score=0    
          elsif @player.strike1==true  
            if @player.count!=10
              @player.st1_score+=@player.cell1+@player.cell2
              @player.score=@player.st1_score+@player.cell1+@player.cell2
              @player.strike1=nil
              @player.st1_score=0   
            else
              if @player.cell1!=10
                @player.st1_score+=@player.cell2
                @player.score=@player.st1_score+@player.cell1+@player.cell2
              else
                @player.score+=@player.cell2 
              end
            end 
          else
              @player.score+=@player.cell1+@player.cell2
          end 
          if @player.count!=10
            if (@player.cell1+@player.cell2)==10
              @player.spare=true
            end 
            @player.cell1=nil
            @player.cell2=nil 
          end  
          if @player.count!=10
            @player.count+=1 
          else
            if (@player.cell1+@player.cell2)<10
              @player.gameover=true
            end
          end    
        else 
          if @player.count==10
            if @player.cell1==10 or (@player.cell1+@player.cell2)==10
              @player.cell3=@player.throw
              @player.score+=@player.cell3
              @player.gameover=true
            end
          end
        end    
      end    
      @player.update(player_params)
    else
      render :index
    end
  end

  def destroy
    @player = Player.find(params[:id])
    @player.destroy
    redirect_to root_path
  end
  
  private
    def player_params
      params.require(:player).permit(:name, :cell1, :cell2, :cell3, :count, :spare, :score, :throw, :strike1,
      :st1_score, :st1_count, :strike2, :st2_score, :st2_count, :st3_score, :gameover, :notice)
    end
end  



