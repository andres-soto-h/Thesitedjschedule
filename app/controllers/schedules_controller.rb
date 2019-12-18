class SchedulesController < ApplicationController
  before_action :authenticate_student!,  except: [:new, ]
  skip_before_action :verify_authenticity_token  
  
  respond_to :html, :json

  def index
 
    @room_id=params[:room_id]
    @user_conected = User.find_by(email: current_student.email)
    @active_suscription = Suscription.find_by(user_id: @user_conected.id, status: true)
    @reservations = Reservation.where(room: @room_id)
    
    respond_to do |format|

      format.html {}
      format.json { render json: @reservations }
    
     end

  end

  def new

    @reservation = Reservation.new(schedules_params)

    if Reservation.exists?(start_hour: params[:start_hour], reserve_date:params[:reserve_date], room: params[:room])
        render :json => {:result => "Error, schedule already exist!", :status_code => "0"}
    else
      if @reservation.save
        render :json => {:result => "Data saved successfully!",:status_code => "1"}
      end
    end
  
  end

  def destroy
    
    @user_conected = User.find_by(email: current_student.email)
    @active_suscription = Suscription.find_by(user_id: @user_conected.id, status: true)

    if @active_suscription.id.to_i==params[:suscription_id].to_i
      Reservation.where(id: params[:id]).destroy_all
      
      render :json => {
        :result => "Data deleted successfully!",
        :status_code => "1"
      }
    else
      render :json => {:result => "Error, can't delete!", :status_code => "0"}
    end

  end


  private
  def schedules_params
    params.permit(:suscription_id, :schedule_id, :start_hour, :reserve_date, :room)
  end

end
