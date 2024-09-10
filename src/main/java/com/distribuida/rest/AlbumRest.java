package com.distribuida.rest;

import com.distribuida.db.Album;
import com.distribuida.repo.IAlbumRepo;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("/albums")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@ApplicationScoped
@Transactional
public class AlbumRest {

    @Inject
    private IAlbumRepo albumRepo;

    @GET
    public List<Album> findAll(){
        return albumRepo.listAll();
    }

    @GET
    @Path("/{id}")
    public Response findById(@PathParam("id") int id){
        var album = albumRepo.findByIdOptional(id);
        if(album.isEmpty()){
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.ok(album.get()).build();
    }

    @POST
    public Response create(Album album){
        albumRepo.persist(album);
        return Response.status(Response.Status.CREATED).build();
    }

    @PUT
    @Path("/{id}")
    public Response update(@PathParam("id") int id, Album album){
        Album a = albumRepo.findById(id);
        if(a == null){
            return Response.status(Response.Status.NOT_FOUND).build();
        }

        a.setId(album.getId());
        a.setSingerId(album.getSingerId());
        a.setTitle(album.getTitle());
        a.setRelease_date(album.getRelease_date());

        albumRepo.persist(a);
        return Response.ok(a).build();
    }

    @DELETE
    @Path("/{id}")
    public Response delete(@PathParam("id") int id){
        albumRepo.deleteById(id);
        return Response.ok().build();
    }
}
